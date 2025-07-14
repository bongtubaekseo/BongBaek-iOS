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
    
    private let authService: AuthServiceProtocol
    private let keychainManager = KeychainManager.shared

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
    func loginWithKakao(kakaoToken: String) {
        authState = .loading
        
        authService.login(accessToken: kakaoToken)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("로그인 실패: \(error)")
                        self?.authState = .needsLogin
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleLoginResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 회원가입
    func signUp(memberInfo: MemberInfo) {
        authState = .loading
        
        authService.signUp(memberInfo: memberInfo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("회원가입 실패: \(error)")
                        self?.authState = .needsSignUp
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
        guard let accessToken = keychainManager.accessToken else {
            authState = .needsLogin
            return
        }
        
        // 저장된 토큰으로 자동 로그인 시도
        // 여기서는 토큰이 있으면 일단 authenticated로 처리
        authState = .authenticated
        
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
        
        // TokenInfo 확인 및 저장
        guard let tokenInfo = authData.token else {
            print("토큰 정보가 없습니다")
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
            // 회원가입 완료 여부에 따라 상태 결정
            authState = authData.isCompletedSignUp ? .authenticated : .needsSignUp
            print("로그인 성공, 회원가입 완료: \(authData.isCompletedSignUp)")
            
        case .failure(let error):
            print("토큰 저장 실패: \(error)")
            authState = .needsLogin
        }
    }
    
    private func handleSignUpResponse(_ response: SignUpResponse) {
        // BaseResponse 성공 여부 확인
        guard response.isSuccess else {
            print("회원가입 API 실패: \(response.message)")
            authState = .needsSignUp
            return
        }
        
        // AuthData 확인
        guard let authData = response.data else {
            print("회원가입 응답 데이터가 없습니다")
            authState = .needsSignUp
            return
        }
        
        // TokenInfo 확인 및 업데이트 (회원가입 후 새로운 토큰이 올 수 있음)
        if let tokenInfo = authData.token {
            let saveResult = keychainManager.saveTokens(
                access: tokenInfo.accessToken,
                refresh: tokenInfo.refreshToken
            )
            
            switch saveResult {
            case .success:
                authState = .authenticated
                print("회원가입 완료 및 토큰 업데이트 성공")
                
            case .failure(let error):
                print("토큰 업데이트 실패: \(error)")
                authState = .needsSignUp
            }
        } else {
            // 토큰 정보가 없어도 회원가입은 성공
            authState = .authenticated
            print("회원가입 완료")
        }
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
