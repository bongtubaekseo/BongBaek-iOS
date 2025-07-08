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
                VStack(spacing: 20) {
                    Text("결혼식")
                        .bodyMedium14()
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.primaryNormal, lineWidth: 1)
                                .background(.gray750)
                        )
                    
                    VStack(spacing: 20) {
                        Text("추천 금액")
                            .captionRegular12()
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.primaryNormal)
                            )
                        HStack(alignment: .bottom, spacing: 4) {
                            Text("100,000")
                                .font(.system(size: 46, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#4E62FF"),
                                            Color(hex: "#502EFF")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("원")
                                .titleSemiBold22()
                                .foregroundColor(.gray600)
                                .padding(.bottom, 8)
                        }
                        VStack(spacing: 2) {
                            Text("적절한 금액이에요!")
                                .bodyMedium16()
                                .foregroundColor(.white)
                            
                            Text("알려주신 정보를 고려한 추천입니다")
                                .bodyRegular14()
                                .foregroundColor(.gray200)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray750.opacity(0.6))
                        )
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
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
                    )
                    .padding(.horizontal, 20)
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }
}

#Preview {
    RecommendLottie()
}
