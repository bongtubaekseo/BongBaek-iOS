//
//  RootView.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct RootView: View {
    @State private var showLoginView = false
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        Group {
            switch appStateManager.currentState {
            case .launch:
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            appStateManager.checkAuthStatus()
                        }
                    }
            case .login:
                MainTabView()
                    .environmentObject(appStateManager)
                
            case .main:
                MainTabView()
                    .environmentObject(appStateManager)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appStateManager.currentState)
        .sheet(isPresented: $appStateManager.showSignUpSheet) {
            SignUpBottomSheetView {
                print("hi")
            }
                .environmentObject(appStateManager)
        }

    }
}


