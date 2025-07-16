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
        print("📱 AppStateManager - Auth 상태 변경: \(authState)")
        print("📱 현재 앱 상태: \(currentState)")
        
        switch authState {
        case .authenticated:
            print("인증 완료 - 메인 화면으로 이동")
            withAnimation {
                currentState = .main
                showSignUpSheet = false
            }
            
        case .needsSignUp:
            print("📝 회원가입 필요 - 시트 표시")
            withAnimation {
                showSignUpSheet = true
            }
        case .loading:
            print("로딩")
        case .needsLogin:  //
            print("🔑 로그인 필요 - 로그인 화면으로 이동")
            withAnimation {
                currentState = .login
                showSignUpSheet = false
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


