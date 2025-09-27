//
//  LoginView.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI

struct LoginView: View {
    @State var isPresented = false
    @State private var showProfileSetting = false
    @EnvironmentObject var appStateManager: AppStateManager
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var test = false
//    @Environment(\.openURL) private var openURL
    
    
   var body: some View {
       
       NavigationStack {
           VStack(spacing: 0) {
               
               VStack {
                   WelcomeTextView()
                       .padding(.top, 144.adjustedH)
                       .padding(.leading, 20)
               }
               
               Spacer()
               
               VStack(spacing: 0) {
                   
                   VStack(spacing: 20) {
                       Button(action: {

                       }) {
                           Image("btn_login_apple")
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
                       .overlay {
                           loginViewModel.requestAppleOauth()
                               .frame(maxWidth: 375)
                               .frame(height: 44)
                               .blendMode(.hue)
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
                           .foregroundStyle(.white)

                       HStack {
                           Text("개인정보 처리방침")
                               .captionRegular12()
                               .foregroundStyle(.white)
                               .underline()
                               .onTapGesture {
                                   loginViewModel.openPrivacyPolicy()
                               }

                           Text("이용약관")
                               .captionRegular12()
                               .foregroundStyle(.white)
                               .underline()
                               .padding(.leading, 12)
                               .onTapGesture {
                                   loginViewModel.openTermsOfUse()
                               }
                       }
                       .padding(.leading, 50)
                       .padding(.top,12)
                   }
                   .padding(.horizontal, 20)
                   .padding(.top,12.adjustedH)
               }
               
               Rectangle()
                   .frame(height: 60.adjustedH)
                   .foregroundStyle(.clear)

           }
           .background(
               Image("onboarding_ios")
                   .resizable()
                   .scaledToFill()
                   .ignoresSafeArea()
           )
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
}

