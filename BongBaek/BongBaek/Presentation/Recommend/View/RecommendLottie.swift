//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    @State private var showRectangle = false
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        ZStack {
            if !showRectangle {
                LottieView(
                    animationFileName: "envelope",
                    loopMode: .playOnce,
                    completion: { finished in
                        if finished {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showRectangle = true
                            }
                        }
                    }
                )
            }
            
            if showRectangle {
                RecommendCostView()
                    .environmentObject(router)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .onAppear {
            print("⏳ RecommendLottie 나타남 - path.count: \(router.path.count)")
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }
}

#Preview {
    RecommendLottie()
}
