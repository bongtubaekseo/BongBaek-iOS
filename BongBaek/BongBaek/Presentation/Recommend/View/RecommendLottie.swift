//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    @State private var showRectangle = false
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
                VStack(alignment: .center){
                    Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#A6BEF3"),
                                Color(hex: "#D3D9FF")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
//                .padding(.top, 20)
//                .padding(.vertical, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }
}

#Preview {
    RecommendLottie()
}
