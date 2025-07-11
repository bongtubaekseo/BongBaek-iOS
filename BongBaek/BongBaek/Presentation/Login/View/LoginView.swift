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
                           isPresented = true
                       }) {
                           Image("btn_kakao")
                               .resizable()
                               .scaledToFit()
                               .frame(maxWidth: .infinity)
                               .frame(height: 52)
                       }
                       .buttonStyle(PlainButtonStyle())
                       .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

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
       }
       .sheet(isPresented: $isPresented) {
           SignUpBottomSheetView(
               onComplete: {
                   print("SignUpBottomSheet Clicked()")
                   isPresented = false
                   showProfileSetting = true
               }
           )
           .presentationDetents([.medium])
           .presentationDragIndicator(.visible)
       }
   }
}

