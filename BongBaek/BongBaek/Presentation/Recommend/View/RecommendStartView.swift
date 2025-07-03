//
//  RecommendStartView.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct RecommendStartView: View {
    var body: some View {
        VStack {
            CustomNavigationBar(title: "금액 추천 가이드")
            
            RecommendGuideTextView()
                .padding(.leading, 10)
            
            Image("image_bong 1")
            
            HStack {
                Image("icon_protect")
                Text("개인정보 보호모드 작동 중 ")
                    .bodyMedium14()
                    .foregroundStyle(.gray300)
            }
            
            Button {
                print("금액추천 시작하기")
            } label: {
                Text("금액 추천 시작하기")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.primaryNormal)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top,8)

            Spacer()
        }
    }
}

