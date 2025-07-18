//
//  AuthManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import Foundation
import Combine

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var authState: AuthState = .loading
    @Published var currentKakaoId: Int? = nil
    @Published var signUpError: String? = nil
    
    private let authService: AuthServiceProtocol
    private let keychainManager = KeychainManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared

    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.authService = DIContainer.shared.authService
    }
    
    
    enum AuthState {
        case loading
        case authenticated
        case needsLogin
        case needsSignUp
    }
    
    // MARK: - 카카오 로그인 후 처리
    
    func loginWithKakao() async {
        authState = .loading
        keychainManager.clearTokens()
        
        do {
            // 1. 카카오에서 토큰 획득
            let kakaoToken = try await kakaoLoginManager.login()
            print("카카오 로그인 성공, accessToken: \(kakaoToken)")
            
            // 2. 서버에 카카오 토큰 전송하여 앱 토큰 획득
            await loginWithKakaoToken(kakaoToken)
            
        } catch {
            print("카카오 로그인 실패: \(error)")
            authState = .needsLogin
        }
    }
    
    private func loginWithKakaoToken(_ kakaoToken: String) async {
        
        authService.login(accessToken: kakaoToken)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("서버 로그인 실패: \(error)")
                        self?.authState = .needsLogin
                    }
                },
                receiveValue: { [weak self] response in
                    print("response:123 \(response)")
                    self?.handleLoginResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 회원가입
    func signUp(memberInfo: MemberInfo) {
        authState = .loading
        signUpError = nil  // 에러 초기화
        
        authService.signUp(memberInfo: memberInfo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("회원가입 네트워크 실패: \(error)")
                        self?.signUpError = "네트워크 오류가 발생했습니다. 다시 시도해주세요."
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleSignUpResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 자동 로그인
    func checkAuthStatus() {
        print("🔍 AuthManager - 인증 상태 확인 시작")
        
        guard let accessToken = keychainManager.accessToken else {
            print("❌ Keychain에 저장된 accessToken 없음")
            print("🔄 authState를 .needsLogin으로 변경")
            authState = .needsLogin
            return
        }
        
        print("✅ Keychain에서 accessToken 발견:")
        print("   - 토큰 길이: \(accessToken.count)자")
        print("   - 토큰 앞 10자: \(String(accessToken.prefix(10)))...")
        print("   - 전체 토큰: \(accessToken)")
        
        // 저장된 토큰으로 자동 로그인 시도
        print("🔄 authState를 .authenticated로 변경")
        authState = .authenticated
        
        print("💡 TODO: 실제로는 토큰 유효성 검증 API 호출 필요")
        // TODO: 실제로는 토큰 유효성 검증 API 호출
        // validateToken(accessToken)
    }
    
    // MARK: - 토큰 갱신
    func refreshTokens() {
        guard let refreshToken = keychainManager.refreshToken else {
            logout()
            return
        }
        
        authService.retryToken()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("토큰 갱신 실패: \(error)")
                        self?.logout()
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleRefreshTokenResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 로그아웃
    func logout() {
        let result = keychainManager.clearTokens()
        if case .failure(let error) = result {
            print("토큰 삭제 실패: \(error)")
        }
        currentKakaoId = nil
        authState = .needsLogin
    }
    
    // MARK: - Private Response Handlers
    
    private func handleLoginResponse(_ response: LoginResponse) {
        // BaseResponse 성공 여부 확인
        guard response.isSuccess else {
            print("로그인 API 실패: \(response.message)")
            authState = .needsLogin
            return
        }
        
        // AuthData 확인
        guard let authData = response.data else {
            print("로그인 응답 데이터가 없습니다")
            authState = .needsLogin
            return
        }
        
        currentKakaoId = authData.kakaoId
        print("저장된 kakaoId: \(currentKakaoId ?? 0)")
        
        // 회원가입 완료 여부 먼저 확인
        if authData.isCompletedSignUp {
            // 기존 회원 - 토큰이 있어야 함
            guard let tokenInfo = authData.token else {
                print("기존 회원인데 토큰 정보가 없습니다")
                authState = .needsLogin
                return
            }
            
            // 키체인에 토큰 저장
            let saveResult = keychainManager.saveTokens(
                access: tokenInfo.accessToken,
                refresh: tokenInfo.refreshToken
            )
            
            switch saveResult {
            case .success:
                authState = .authenticated
                print("기존 회원 로그인 성공")
                
            case .failure(let error):
                print("토큰 저장 실패: \(error)")
                authState = .needsLogin
            }
            
        } else {
            // 신규 회원 - 토큰이 없을 수 있음, 회원가입 필요
            print("신규 회원 - 회원가입 필요")
            print("kakaoId: \(authData.kakaoId)")
            
            // 회원가입이 필요한 상태로 설정
            authState = .needsSignUp
            
            // 만약 토큰이 있다면 임시로 저장 (회원가입 과정에서 사용할 수 있음)
            if let tokenInfo = authData.token {
                let saveResult = keychainManager.saveTokens(
                    access: tokenInfo.accessToken,
                    refresh: tokenInfo.refreshToken
                )
                
                if case .failure(let error) = saveResult {
                    print("임시 토큰 저장 실패: \(error)")
                }
            }
        }
    }
    
    private func handleSignUpResponse(_ response: SignUpResponse) {
           print("📤 회원가입 응답 받음:")
           print("  - isSuccess: \(response.isSuccess)")
           print("  - message: \(response.message)")
           print("  - data: \(response.data)")
           
           guard response.isSuccess else {
               print("❌ 회원가입 API 실패: \(response.message)")
               // 실패 시 에러 메시지 설정 (authState는 변경하지 않음)
               signUpError = response.message.isEmpty ? "회원가입에 실패했습니다. 다시 시도해주세요." : response.message
               return
           }
           
           guard let authData = response.data else {
               print("❌ 회원가입 응답 데이터가 없습니다")
               signUpError = "서버 응답 오류가 발생했습니다. 다시 시도해주세요."
               return
           }
           
           print("✅ 회원가입 응답 데이터 있음")
           
           if let tokenInfo = authData.token {
               print("🔑 토큰 정보 있음, 키체인에 저장 시도")
               let saveResult = keychainManager.saveTokens(
                   access: tokenInfo.accessToken,
                   refresh: tokenInfo.refreshToken
               )
               
               switch saveResult {
               case .success:
                   print("✅ 토큰 저장 성공 - authenticated 상태로 변경")
                   authState = .authenticated
                   
               case .failure(let error):
                   print("❌ 토큰 저장 실패: \(error)")
                   signUpError = "토큰 저장에 실패했습니다. 다시 시도해주세요."
               }
           } else {
               print("✅ 토큰 없어도 회원가입 완료 - authenticated 상태로 변경")
               authState = .authenticated
           }
           
           print("🔄 최종 authState: \(authState)")
       }
    
    private func handleRefreshTokenResponse(_ response: RefreshTokenResponse) {
        // BaseResponse 성공 여부 확인
        guard response.isSuccess else {
            print("토큰 갱신 API 실패: \(response.message)")
            logout()
            return
        }
        
        // TokenInfo 확인
        guard let tokenInfo = response.data else {
            print("토큰 갱신 응답 데이터가 없습니다")
            logout()
            return
        }
        
        // 새로운 액세스 토큰 저장
        let updateResult = keychainManager.updateAccessToken(tokenInfo.accessToken)
        
        switch updateResult {
        case .success:
            print("토큰 갱신 성공")
            // 상태는 유지 (이미 authenticated 상태)
            
        case .failure(let error):
            print("토큰 업데이트 실패: \(error)")
            logout()
        }
    }
    
    func getCurrentKakaoId() -> String {
        guard let kakaoId = currentKakaoId else {
            print("kakaoId가 없습니다. 로그인이 필요할 수 있습니다.")
            return "0"
        }
        return String(kakaoId)
    }
    
    func clearSignUpError() {
            signUpError = nil
        }
}

// MARK: - extension
extension AuthManager {
    var isAuthenticated: Bool {
        return authState == .authenticated
    }
    
    var currentAccessToken: String? {
        return keychainManager.accessToken
    }
    
    var hasValidTokens: Bool {
        return keychainManager.hasTokens()
    }
}
