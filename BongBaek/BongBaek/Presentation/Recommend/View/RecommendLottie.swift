//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    CustomNavigationBar(title: "금액추천")
                    VStack(spacing: 30) {
                        Spacer()
                        Lottie(animationFileName: "envelope", loopMode: .playOnce)
                            .frame(width: 335, height: 230)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RecommendLottie()
}
