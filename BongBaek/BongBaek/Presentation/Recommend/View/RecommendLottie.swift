//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    @StateObject private var lottieviewModel = RecommendCostViewModel()
    @State private var showRectangle = false

    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack {
            if !showRectangle {
                VStack(spacing: 30) {
                    Spacer()
                    
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
                    .offset(y: -20)
                    
                    VStack(spacing: 40) {
                        amountRangeSection
                        categorySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    Spacer()
                }
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
    
    var amountRangeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("적정 범위")
                .titleSemiBold18()
                .foregroundColor(.white)

            VStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex:"#292929"))
                        .frame(width: 300, height: 12)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                               LinearGradient(
                                   colors: [
                                       Color(hex: "#502EFF"),
                                       Color(hex: "#807FFF")
                                   ],
                                   startPoint: .leading,
                                   endPoint: .trailing
                               )
                           )
                        .frame(width: 5, height: 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("\(lottieviewModel.formattedMinAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    
                    Spacer()
                    
                    Text("\(lottieviewModel.formattedMaxAmount)원")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
        )
    }

    var categorySection: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.gray900)
                        .frame(width: 40, height: 40)
                    
                    Image("icon_star")
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("경조사 종류")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    Text("결혼식")
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(width: 163, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.gray900)
                        .frame(width: 40, height: 40)
                    
                    Image("icon_location 2")
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("장소")
                        .captionRegular12()
                        .foregroundColor(.gray400)
                    Text("강남 웨딩홀")
                        .bodyMedium16()
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(width: 164, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("gray750"))
            )
        }
    }
}
