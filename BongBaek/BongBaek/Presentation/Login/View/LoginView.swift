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
    
   var body: some View {
  
       NavigationStack {
           GeometryReader { geometry in
               Image("onboarding_ios")
                   .resizable()
                   .scaledToFill()
                   .ignoresSafeArea()
               
               VStack {
                   WelcomeTextView()
                       .ignoresSafeArea()
                       .padding(.top,144)
                       .padding(.leading, 20)
                   
                   Spacer()
                   
                   VStack(spacing: 16) {

                       Button(action: {
                           appStateManager.loginWithKakao()
                           // ToDo - viewModel.kakaoLogin 시작하는 로직
                       }) {
                           Image("btn_kakao")
                               .resizable()
                               .scaledToFit()
                               .frame(maxWidth: .infinity)
                               .frame(height: 52)
                       }
                       .buttonStyle(PlainButtonStyle())
                       .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                       .disabled(loginViewModel.isLoading)
                       .overlay(
                           loginViewModel.isLoading ?
                           ProgressView().tint(.white) : nil
                       )


                     
                       VStack(alignment: .leading,spacing: 8) {
                           Text("로그인하시면 아래 내용에 동의하는 것으로 간주됩니다.")
                               .captionRegular12()
                               .foregroundStyle(.white)

                           HStack {
                               Text("개인정보 처리방침")
                                   .captionRegular12()
                                   .foregroundStyle(.white)
                                   .underline()

                               Text("이용약관")
                                   .captionRegular12()
                                   .foregroundStyle(.white)
                                   .underline()
                                   .padding(.leading, 12)
                           }
                           .padding(.leading, 50)

                       }
                   }
                   .padding(.horizontal, 20)
                   .padding(.bottom, 30)
               }
               
           }
           .navigationDestination(isPresented: $showProfileSetting) {
               ProfileSettingView()
           }
           .alert("로그인 실패", isPresented: $loginViewModel.showError) {
               Button("확인") { }
           } message: {
               Text(loginViewModel.errorMessage ?? "알수 없는 에러가 발생했습니다.")
           }
       }
       .sheet(isPresented: $appStateManager.showSignUpSheet) {
           SignUpBottomSheetView(
               onComplete: {
                   print("SignUpBottomSheet Clicked()")
                   appStateManager.showSignUpSheet = false
                   showProfileSetting = true
               }
           )
           .presentationDetents([.medium])
           .presentationDragIndicator(.visible)
       }
   }
}

