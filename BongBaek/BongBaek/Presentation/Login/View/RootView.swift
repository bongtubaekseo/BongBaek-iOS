//
//  RootView.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI
import FirebaseRemoteConfig

struct RootView: View {
    @State private var showLoginView = false
    @StateObject private var appStateManager = AppStateManager()
    @State private var showForceUpdateAlert = false
    @State private var forceUpdateMessage = ""
    
    var body: some View {
        Group {
            switch appStateManager.currentState {
            case .launch:
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            checkForceUpdate()
                        }
                    }
            case .login:
                LoginView()
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
        
        .alert("업데이트 필요", isPresented: $showForceUpdateAlert) {
            Button("업데이트") {
                openAppStore()
            }
        } message: {
            Text(forceUpdateMessage)
        }

    }
    private func checkForceUpdate() {
        Task {
            let result = await RemoteConfigManager.shared.checkForceUpdate()
            
            await MainActor.run {
                if result.isRequired {
                    forceUpdateMessage = result.message
                    showForceUpdateAlert = true
                    
                    switch result.updateType {
                    case .emergency:
                        print("긴급 업데이트 필요")
                    case .version:
                        print("버전 업데이트 필요")
                    case .none:
                        break
                    }

                } else {
                    // 정상 플로우 진행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        appStateManager.checkAuthStatus()
                    }
                }
            }
        }
    }
    
    private func openAppStore() {
         if let url = URL(string: "https://naver.com") {
             UIApplication.shared.open(url)
         }
     }
}


