//
//  RecommendLoadingView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLoadingView: View {
    
    @State private var showSuccessView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
//                    CustomNavigationBar(title: "금액추천중")
                    
                    HStack {
                        
                        Text("금액추천중")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    }
                    VStack(spacing: 30) {
                        Spacer()
                        LottieTest(animationFileName: "find_amount", loopMode: .loop)
                            .frame(width: 151, height: 140)
                        
                        Text("{username}님을 위한\n급액을 찾고 있어요")
                            .titleSemiBold18()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray100)
                                        
                        Text("잠시만 기다려주세요")
                            .bodyRegular14()
                            .foregroundColor(.gray400)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showSuccessView = true
                    }
                }
                .navigationDestination(isPresented: $showSuccessView) {
                    RecommendLottie()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RecommendLoadingView()
}
