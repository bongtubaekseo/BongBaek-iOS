//
//  AppStateManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/12/25.
//

import SwiftUI

enum AppState {
    case launch
    case login
//    case signUp
    case main
}

class AppStateManager: ObservableObject {
    @Published var currentState: AppState = .launch
    @Published var authData: AuthData?
    @Published var showSignUpSheet = false
    
    func moveToLogin() {
        withAnimation {
            currentState = .login
        }
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
        }
    }
}


