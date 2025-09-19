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
    @Published var currentKakaoId: String? = nil
    @Published var currentAppleId: String? = nil
    @Published var loginType: LoginType? = nil
    @Published var signUpError: String? = nil
    
    enum LoginType {
        case kakao
        case apple
    }
    
    private let authService: AuthServiceProtocol
    private let keychainManager = KeychainManager.shared
    private let kakaoLoginManager = KakaoLoginManager.shared

    private var cancellables = Set<AnyCancellable>()
    
    private let accessTokenExpiryKey = "accessTokenExpiry"
    private let refreshTokenExpiryKey = "refreshTokenExpiry"
    
    private init() {
        self.authService = DIContainer.shared.authService
    }
    
    enum AuthState {
        case loading
        case authenticated
        case needsLogin
        case needsSignUp
    }
    
    // MARK: - 토큰 만료 체크 메서드들
    
    /// 현재 시간을 밀리초로 반환
    private var currentTimeMillis: Double {
        return Date().timeIntervalSince1970 * 1000
    }
    
    /// AccessToken 만료 여부 확인
    private func isAccessTokenExpired() -> Bool {
        let expiry = UserDefaults.standard.double(forKey: accessTokenExpiryKey)
        guard expiry > 0 else { return true } // 만료 정보가 없으면 만료된 것으로 간주
        return currentTimeMillis > expiry
    }
    
    /// RefreshToken 만료 여부 확인
    private func isRefreshTokenExpired() -> Bool {
        let expiry = UserDefaults.standard.double(forKey: refreshTokenExpiryKey)
        guard expiry > 0 else { return true }
        return currentTimeMillis > expiry
    }
    
    /// AccessToken 남은 시간(분) 반환
    private func accessTokenRemainingMinutes() -> Double {
        let expiry = UserDefaults.standard.double(forKey: accessTokenExpiryKey)
        let remaining = (expiry - currentTimeMillis) / 1000 / 60
        return max(0, remaining)
    }
    
    /// 토큰 만료 정보 저장
    private func saveTokenExpiry(accessExpiry: Int, refreshExpiry: Int) {
        UserDefaults.standard.set(accessExpiry, forKey: accessTokenExpiryKey)
        UserDefaults.standard.set(refreshExpiry, forKey: refreshTokenExpiryKey)
        
        print("토큰 만료 시간 저장:")
        print("  - AccessToken 만료: \(Date(timeIntervalSince1970: Double(accessExpiry) / 1000))")
        print("  - RefreshToken 만료: \(Date(timeIntervalSince1970: Double(refreshExpiry) / 1000))")
    }
    
    /// 토큰 만료 정보 삭제
    private func clearTokenExpiry() {
        UserDefaults.standard.removeObject(forKey: accessTokenExpiryKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenExpiryKey)
    }
    
    // MARK: - 로그인 상태 체크
    
    func checkAuthStatus() {
        print("========== AuthManager - 토큰 기반 인증 상태 확인 ==========")
        
        // 1. 키체인에 토큰이 있는지 확인
        guard keychainManager.hasTokens() else {
            print("키체인에 토큰 없음 - 로그인 필요")
            authState = .needsLogin
            return
        }
        
        print("키체인에 토큰 존재")
        
        // 2. RefreshToken 만료 체크
        if isRefreshTokenExpired() {
            print("RefreshToken 만료 - 재로그인 필요")
            clearAllTokensAndData()
            authState = .needsLogin
            return
        }
        
        print("RefreshToken 유효")
        
        // 3. AccessToken 만료 체크
        if isAccessTokenExpired() {
            print("AccessToken 만료 - 자동 갱신 시도")
            authState = .loading
            refreshTokens()
            return
        }
        
        // 4. AccessToken 유효 - 미리 갱신 체크
        let remainingMinutes = accessTokenRemainingMinutes()
        print("AccessToken 유효 - 남은 시간: \(Int(remainingMinutes))분")
        
        if remainingMinutes < 30 { // 30분 미만 남았을 때 미리 갱신
            print("토큰 곧 만료 - 미리 갱신")
            refreshTokens()
        }
        
        authState = .authenticated
        print("=========================================================")
    }
    
    // MARK: - 카카오 로그인
    
    func loginWithKakao() async {
        authState = .loading
        clearAllTokensAndData()
        
        do {
            let kakaoToken = try await kakaoLoginManager.login()
            print("카카오 로그인 성공, accessToken: \(kakaoToken)")
            await loginWithKakaoToken(kakaoToken)
        } catch {
            print("카카오 로그인 실패: \(error)")
            authState = .needsLogin
        }
    }
    
    private func loginWithKakaoToken(_ kakaoToken: String) async {
        authService.kakaoLogin(accessToken: kakaoToken)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("서버 로그인 실패: \(error)")
                        self?.authState = .needsLogin
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleKaKaoLoginResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 애플 로그인
    
    func loginWithApple(idToken: String) async {
        authState = .loading
        clearAllTokensAndData()
        
        print("애플 로그인 시작, idToken: \(idToken)")
        await loginWithAppleToken(idToken)
    }
    
    func loginWithAppleToken(_ idToken: String) async {
        authService.appleLogin(idToken: idToken)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("애플 서버 로그인 실패: \(error)")
                        self?.authState = .needsLogin
                    }
                },
                receiveValue: { [weak self] response in
                    self?.handleAppleLoginResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 회원가입
    
    func signUp(memberInfo: MemberInfo) {
        authState = .loading
        signUpError = nil
        
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
    
    // MARK: - 토큰 갱신
    
    func refreshTokens() {
        guard !isRefreshTokenExpired() else {
            print("RefreshToken 만료 - 로그아웃 처리")
            logout()
            return
        }
        
        print("토큰 갱신 시작")
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
    
    // MARK: - 로그아웃 & 정리
    
    func logout() {
        authService.logout()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("로그아웃 API 호출 실패: \(error)")
                    }
                },
                receiveValue: { response in
                    print("로그아웃 응답: \(response)")
                }
            )
            .store(in: &cancellables)
        
        clearAllTokensAndData()
        authState = .needsLogin
    }
    
    /// 모든 토큰과 관련 데이터 정리
     func clearAllTokensAndData() {
        // 키체인 토큰 삭제
        let result = keychainManager.clearTokens()
        if case .failure(let error) = result {
            print("키체인 토큰 삭제 실패: \(error)")
        }
        
        // 토큰 만료 정보 삭제
        clearTokenExpiry()
        
        // 사용자 정보 초기화
        currentKakaoId = nil
        currentAppleId = nil
        loginType = nil
        signUpError = nil
        
        print("모든 토큰 및 사용자 데이터 정리 완료")
    }
    
    // MARK: - 회원탈퇴
    func withdraw(reason: WithdrawRequestData, completion: @escaping (Bool) -> Void) {
        authService.withdraw(reason: reason)
            .sink(
                receiveCompletion: { completionResult in
                    if case .failure(let error) = completionResult {
                        print("회원탈퇴 API 호출 실패: \(error)")
                        completion(false)
                    } else {
                        print("회원탈퇴 API 호출 성공")
                        completion(true)
                    }
                },
                receiveValue: { response in
                    print("회원탈퇴 응답: \(response)")
                }
            )
            .store(in: &cancellables)
    }
    
    func completeWithdrawal() {
        clearAllTokensAndData()
        authState = .needsLogin
    }
    
    
    
    private func handleKaKaoLoginResponse(_ response: KaKaoLoginResponse) {
        guard response.isSuccess, let authData = response.data else {
            print("카카오 로그인 API 실패: \(response.message)")
            authState = .needsLogin
            return
        }
        
        currentKakaoId = authData.kakaoId
        loginType = .kakao
        
        if let apiKey = authData.apiKey {
            UserDefaults.standard.set(apiKey, forKey: "apiKey")
            print("카카오 로그인 시 API Key 저장: \(apiKey)")
        }
        
        handleAuthData(authData)
    }
    
    private func handleAppleLoginResponse(_ response: AppleLoginResponse) {
        guard response.isSuccess, let authData = response.data else {
            print("애플 로그인 API 실패: \(response.message)")
            authState = .needsLogin
            return
        }
        
        currentAppleId = authData.appleId
        loginType = .apple
        
        if let apiKey = authData.apiKey {
            UserDefaults.standard.set(apiKey, forKey: "apiKey")
            print("애플 로그인 시 API Key 저장: \(apiKey)")
        }
        
        handleAppleAuthData(authData)
    }
    
    /// 공통 AuthData 처리 (카카오용)
    private func handleAuthData(_ authData: AuthData) {
        if authData.isCompletedSignUp {
            // 기존 회원
            guard let tokenInfo = authData.token else {
                print("기존 회원인데 토큰 정보가 없습니다")
                authState = .needsLogin
                return
            }
            
            saveTokensWithExpiry(tokenInfo)
            authState = .authenticated
            print("기존 회원 로그인 성공")
            
        } else {
            // 신규 회원 - 회원가입 필요
            print("신규 회원 - 회원가입 필요")
            
            // 임시 토큰이 있다면 저장
            if let tokenInfo = authData.token {
                saveTokensWithExpiry(tokenInfo)
            }
            
            authState = .needsSignUp
        }
    }
    
    /// 애플 AuthData 처리
    private func handleAppleAuthData(_ authData: AppleAuthData) {
        if authData.isCompletedSignUp {
            // 기존 회원
            guard let tokenInfo = authData.token else {
                print("기존 회원인데 토큰 정보가 없습니다")
                authState = .needsLogin
                return
            }
            
            saveTokensWithExpiry(tokenInfo)
            authState = .authenticated
            print("애플 기존 회원 로그인 성공")
            
        } else {
            // 신규 회원 - 회원가입 필요
            print("애플 신규 회원 - 회원가입 필요")
            
            // 임시 토큰이 있다면 저장
            if let tokenInfo = authData.token {
                saveTokensWithExpiry(tokenInfo)
            }
            
            authState = .needsSignUp
        }
    }
    
    private func handleSignUpResponse(_ response: SignUpResponse) {
        print("회원가입 응답:")
        print("  - isSuccess: \(response.isSuccess)")
        print("  - message: \(response.message)")
        
        guard response.isSuccess else {
            signUpError = response.message.isEmpty ? "회원가입에 실패했습니다." : response.message
            return
        }
        
        guard let authData = response.data else {
            signUpError = "서버 응답 오류가 발생했습니다."
            return
        }
        
        if let tokenInfo = authData.token {
            saveTokensWithExpiry(tokenInfo)
            
            // 사용자 이름 저장 (name이 있는 경우)
            if let name = authData.name {
                UserDefaults.standard.set(name, forKey: "memberName")
            }
            
            if let apiKey = authData.apiKey {
                UserDefaults.standard.set(apiKey, forKey: "apiKey")
                print("회원가입 시 API Key 저장: \(apiKey)")
            }
            

        }
        
        authState = .authenticated
        print("회원가입 완료 및 로그인 성공")
    }
    
    private func handleRefreshTokenResponse(_ response: RefreshTokenResponse) {
        guard response.isSuccess, let tokenInfo = response.data else {
            print("토큰 갱신 API 실패: \(response.message)")
            logout()
            return
        }
        
        print("토큰 갱신 응답 받음:")
        print("  - 새 AccessToken: \(tokenInfo.accessToken.token.prefix(20))...")
        print("  - 새 RefreshToken: \(tokenInfo.refreshToken.token.prefix(20))...")
        
        // 새로운 AccessToken과 RefreshToken 모두 업데이트
        let accessResult = keychainManager.updateAccessToken(tokenInfo.accessToken.token)
        let refreshResult = keychainManager.updateRefreshToken(tokenInfo.refreshToken.token)
        
        guard case .success = accessResult, case .success = refreshResult else {
            print("토큰 키체인 저장 실패")
            logout()
            return
        }
        
        // 새로운 만료시간들 저장
        saveTokenExpiry(
            accessExpiry: tokenInfo.accessToken.expiredAt,
            refreshExpiry: tokenInfo.refreshToken.expiredAt
        )
        
        print("토큰 갱신 완료:")
        print("  - AccessToken 만료: \(Date(timeIntervalSince1970: Double(tokenInfo.accessToken.expiredAt) / 1000))")
        print("  - RefreshToken 만료: \(Date(timeIntervalSince1970: Double(tokenInfo.refreshToken.expiredAt) / 1000))")
        
        authState = .authenticated
    }
    
    
    /// 토큰 정보를 키체인과 UserDefaults에 저장
    private func saveTokensWithExpiry(_ tokenInfo: TokenInfo) {
        // 1. 키체인에 토큰 저장
        let saveResult = keychainManager.saveTokens(
            access: tokenInfo.accessToken.token,
            refresh: tokenInfo.refreshToken.token
        )
        
        guard case .success = saveResult else {
            print("토큰 저장 실패")
            authState = .needsLogin
            return
        }
        
        // 2. 만료 시간 저장
        saveTokenExpiry(
            accessExpiry: tokenInfo.accessToken.expiredAt,
            refreshExpiry: tokenInfo.refreshToken.expiredAt
        )
        
        print("토큰 및 만료시간 저장 완료")
    }
    
    // MARK: - Utility Methods
    
    func getCurrentKakaoId() -> String {
        return currentKakaoId ?? "0"
    }
    
    func getCurrentAppleId() -> String {
        return currentAppleId ?? "0"
    }
    
    func clearSignUpError() {
        signUpError = nil
    }
}

// MARK: - Extensions

extension AuthManager {
    var isAuthenticated: Bool {
        return authState == .authenticated
    }
    
    var currentAccessToken: String? {
        return keychainManager.accessToken
    }
    
    var hasValidTokens: Bool {
        return keychainManager.hasTokens() && !isRefreshTokenExpired()
    }
    
    /// 디버깅용 토큰 상태 출력
    func printTokenStatus() {
        print("=== 토큰 상태 정보 ===")
        print("키체인 토큰 존재: \(keychainManager.hasTokens())")
        print("AccessToken 만료: \(isAccessTokenExpired())")
        print("RefreshToken 만료: \(isRefreshTokenExpired())")
        print("AccessToken 남은 시간: \(Int(accessTokenRemainingMinutes()))분")
        print("인증 상태: \(authState)")
        print("===================")
    }
}
