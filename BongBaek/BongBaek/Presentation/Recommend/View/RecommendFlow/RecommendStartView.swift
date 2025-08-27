//
//  RecommendStartView.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct RecommendStartView: View {
    @EnvironmentObject var stepManager: GlobalStepManager
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    @State private var navigateToRecommend = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "금액 추천 가이드") {
                router.pop()
            }
            
            RecommendGuideTextView(
                title1: "경조사비,",
                title2: "얼마가 적당할까요?",
                subtitle1: "내 상황에 딱 맞는 경조사비,",
                subtitle2: "지금 바로 알아보세요!"
            )
            .padding(.leading, 20)
            .padding(.top, 40.adjustedH)

            Image("image_bong 1")
                .frame(width: 335.adjusted,height: 335.adjustedH)
                .padding(.top,20.adjustedH)
            
            HStack {
                Image("icon_protect")
                Text("개인정보 보호모드 작동 중 ")
                    .bodyRegular14()
                    .foregroundStyle(.gray300)
            }
            .padding(.top,20.adjustedH)
            
            Button {
                router.push(to: .recommendView)
            } label: {
                HStack {
                    Spacer()
                    Text("금액 추천 시작하기")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: 55)
                .background(.primaryNormal)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20.adjustedH)

            Spacer()
        }
        .onAppear {
            print("🏠 RecommendStartView 나타남 - path.count: \(router.path.count)")
            eventManager.resetAllData()
         }
        .background(Color.background)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}
