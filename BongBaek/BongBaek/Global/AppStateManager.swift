//
//  AppStateManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/12/25.
//

import SwiftUI
import Combine

enum AppState {
    case launch
    case login
    case main
}

@MainActor
class AppStateManager: ObservableObject {
    @Published var currentState: AppState = .launch
    @Published var authData: AuthData?
    @Published var showSignUpSheet = false
    private let authManager = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthStateObserver()
    }
    
    private func setupAuthStateObserver() {
        authManager.$authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authState in
                self?.handleAuthStateChange(authState)
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthStateChange(_ authState: AuthManager.AuthState) {
        switch authState {
        case .loading:
            // 로딩 상태는 현재 상태 유지
            break
            
        case .authenticated:
            withAnimation {
                currentState = .main
                showSignUpSheet = false
            }
            
        case .needsLogin:
            withAnimation {
                currentState = .login
                showSignUpSheet = false
            }
            
        case .needsSignUp:
            // 회원가입이 필요한 경우 시트 표시
            withAnimation {
                showSignUpSheet = true
            }
        }
    }
    
    func checkAuthStatus() {
        // 앱 시작 시 인증 상태 확인
        authManager.checkAuthStatus()
    }
    
    
    func moveToLogin() {
        withAnimation {
            currentState = .login
        }
    }
    
    func loginWithKakao() {
        Task {
            await authManager.loginWithKakao()
        }
    }
    
    func signUp(memberInfo: MemberInfo) {
        authManager.signUp(memberInfo: memberInfo)
    }
    
    func handleLoginResult(_ authData: AuthData) {
        self.authData = authData
        
        if authData.isCompletedSignUp {
            withAnimation {
                currentState = .main
            }
        } else {
            withAnimation {
                showSignUpSheet = true
            }
        }
    }
    
    func completeSignUp() {
        withAnimation {
            currentState = .main
            showSignUpSheet = false
        }
    }
    
    func logout() {
        authManager.logout()
    }
    
    var isAuthenticated: Bool {
        return authManager.isAuthenticated
    }
    
    var hasValidTokens: Bool {
        return authManager.hasValidTokens
    }

}


