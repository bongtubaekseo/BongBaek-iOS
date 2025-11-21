//
//  LoginView.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @State var isPresented = false
    @State private var showProfileSetting = false
    @EnvironmentObject var appStateManager: AppStateManager
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var test = false

   var body: some View {
       
       NavigationStack {
           VStack(spacing: 0) {
               
               VStack {
                   WelcomeTextView()
                       .padding(.top, 133.adjustedH)
                       .padding(.leading, 20)
               }
               
               Spacer()
               
               VStack(spacing: 0) {
                   VStack(spacing: 12) {
                       Button(action: {

                       }) {
                           Image("btn_login_apple")
                               .resizable()
                               .scaledToFill()
                               .frame(height: 54.adjustedH)
                               .clipped()
                               .cornerRadius(8)

                       }
                       .buttonStyle(PlainButtonStyle())
                       .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                       .disabled(loginViewModel.isLoading)
                       .overlay(
                           loginViewModel.isLoading ?
                           ProgressView().tint(.white) : nil
                       )
                       .overlay {
                           appleLoginButton
                       }
                       
                       Button(action: {
                           appStateManager.loginWithKakao()
                           
                       }) {
                           Image("btn_login_kakao")
                               .resizable()
                               .scaledToFill()
                               .frame(height: 55.adjustedH)
                               .clipped()
                               .cornerRadius(8)


                       }
                       .buttonStyle(PlainButtonStyle())
                       .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                       .disabled(loginViewModel.isLoading)
                       .overlay(
                           loginViewModel.isLoading ?
                           ProgressView().tint(.white) : nil
                       )
                   }
                   .padding(.horizontal,20)

                   VStack(alignment: .leading,spacing: 0) {
                       Text("로그인하시면 아래 내용에 동의하는 것으로 간주됩니다.")
                           .captionRegular12()
                           .foregroundStyle(.txtDisplayTierary)

                       HStack {
                           Text("개인정보 처리방침")
                               .captionRegular12()
                               .foregroundStyle(.txtInteractiveInverse)
                               .underline()
                               .onTapGesture {
                                   loginViewModel.openPrivacyPolicy()
                               }

                           Text("이용약관")
                               .captionRegular12()
                               .foregroundStyle(.txtInteractiveInverse)
                               .underline()
                               .padding(.leading, 12)
                               .onTapGesture {
                                   loginViewModel.openTermsOfUse()
                               }
                       }
                       .padding(.leading, 50)
                       .padding(.top,4)
                   }
                   .padding(.horizontal, 20)
                   .padding(.top,20.adjustedH)
               }
               
               Rectangle()
                   .frame(height: 60.adjustedH)
                   .foregroundStyle(.clear)

           }
           .background(.bgDisplaySecondary)
           .navigationDestination(isPresented: $showProfileSetting) {
               ProfileSettingView()
           }
       }
       .onAppear {
           appStateManager.authManager.clearAllTokensAndData()
       }
       .sheet(isPresented: $appStateManager.showSignUpSheet) {
           SignUpBottomSheetView(
               onComplete: {
                   print("SignUpBottomSheet Clicked()")
                   appStateManager.showSignUpSheet = false
                   showProfileSetting = true
               }
           )
           .presentationDetents([.height(439.adjustedH)])
           .presentationDragIndicator(.visible)
       }
   }
    
    private var appleLoginButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
                
            },
            onCompletion: { result in
                switch result {
                    
                case .success(let authResults):
                    if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                        let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
                        let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? ""
                        print("애플 인증 성공 - idToken: \(identityToken), authCode: \(authorizationCode)")
                        loginViewModel.handleAppleLoginSuccess(identityToken: identityToken, authorizationCode: authorizationCode)
                        
                    }
                case .failure(let error):
                    print("error")
                    loginViewModel.handleAppleLoginFailure(error: error)
                }
            }
        )
        .frame(maxWidth: 375)
        .frame(height: 44)
        .blendMode(.hue)
    }
}

