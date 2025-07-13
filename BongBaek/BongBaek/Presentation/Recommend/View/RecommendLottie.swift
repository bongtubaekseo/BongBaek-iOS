//
//  RecommendLottie.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//
import SwiftUI

struct RecommendLottie: View {
    @StateObject private var viewModel = RecommendationAmountViewModel()
    @State private var showRectangle = false
    
    var body: some View {
        ZStack {
            if !showRectangle {
                VStack(spacing: 0) {
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
                    
                    // 삽입된 코드 부분
                    VStack(spacing: 20) {
                        //amountRangeSection
                        categorySection
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            if showRectangle {
                RecommendCostView()
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }
}

//var amountRangeSection: some View {
//    VStack(alignment: .leading, spacing: 16) {
//        Text("적정 범위")
//            .titleSemiBold18()
//            .foregroundColor(.white)
//        
//        //MARK: - 커스텀 슬라이더, (필요 없으면 삭제해도 됨.)
//        VStack(spacing: 8) {
//            ZStack(alignment: .leading) {
//                RoundedRectangle(cornerRadius: 4)
//                    .fill(Color(hex:"#292929"))
//                    .frame(width: 300, height: 12)
//                
//                RoundedRectangle(cornerRadius: 4)
//                    .fill(
//                           LinearGradient(
//                               colors: [
//                                   Color(hex: "#502EFF"),
//                                   Color(hex: "#807FFF")
//                               ],
//                               startPoint: .leading,
//                               endPoint: .trailing
//                           )
//                       )
//                    .frame(width: CGFloat(viewModel.sliderProgress) * 300, height: 12)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        let progress = min(max(0, value.location.x / 300), 1)
//                        let newAmount = Int(progress * Double(viewModel.maxAmount - viewModel.minAmount)) + viewModel.minAmount
//                        viewModel.updateSliderAmount(to: Double(newAmount))
//                    }
//            )
//            
//            HStack {
//                Text("\(viewModel.formattedMinAmount)원")
//                    .captionRegular12()
//                    .foregroundColor(.gray400)
//                
//                Spacer()
//                
//                Text("\(viewModel.formattedMaxAmount)원")
//                    .captionRegular12()
//                    .foregroundColor(.gray400)
//            }
//        }
//    }
//    .padding(16)
//    .background(
//        RoundedRectangle(cornerRadius: 10)
//            .fill(Color.black)
//    )
//}

// MARK: - Category Section
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

#Preview {
    RecommendLottie()
}
