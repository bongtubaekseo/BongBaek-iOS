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
                ZStack {
                    backgroundLayer
                    bottomImageLayer
                    contentLayer(geometry: geometry)
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
                    isPresented = false  // 바텀시트 닫기
                    showProfileSetting = true
                }
            )
            .presentationDetents([.fraction(0.5)])
        }

    }

    private var backgroundLayer: some View {
        Color.background
            .ignoresSafeArea()
    }
    
    private var bottomImageLayer: some View {
           VStack {
              Spacer()

               Image("Vector 1")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(height: 487)
                   .frame(maxWidth: .infinity)
                   .clipped()
           }
           .ignoresSafeArea(.all)
       }

    private func contentLayer(geometry: GeometryProxy) -> some View {
        VStack {
            WelcomeTextView()
                .padding(.top, geometry.safeAreaInsets.top + 60)
                .padding(.leading, 20)
            
            Spacer()
    
            bottomButtonSection(geometry: geometry)
        }
    }
    
   
    private func bottomButtonSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            
            Button(action: {
                isPresented = true
            }) {
                Text("Apple로 계속하기")
                    .titleSemiBold20()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            
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
        .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
    }
}

