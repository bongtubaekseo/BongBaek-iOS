//
//  RecommendStartView.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct RecommendStartView: View {
    let onBackPressed: () -> Void
    @EnvironmentObject var stepManager: GlobalStepManager
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "금액 추천") {
                onBackPressed()
            }
            
            RecommendGuideTextView(
                title1: "경조사비,",
                title2: "얼마가 적당할까요?",
                subtitle1: "내 상황에 딱 맞는 경조사비,",
                subtitle2: "지금 바로 알아보세요!"
            )
            .padding(.leading, 10)
            
            Image("image_bong 1")
            
            HStack {
                Image("icon_protect")
                Text("개인정보 보호모드 작동 중 ")
                    .bodyMedium14()
                    .foregroundStyle(.gray300)
            }
            
            NavigationLink(destination: RecommendView().environmentObject(stepManager)) {
                Text("금액 추천 시작하기")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.primaryNormal)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()
        }
        .background(Color.background)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}
