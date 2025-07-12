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
    @EnvironmentObject var router: NavigationRouter
    @State private var navigateToRecommend = false
    
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
            .padding(.leading, 20)
            
            Image("image_bong 1")
            
            HStack {
                Image("icon_protect")
                Text("개인정보 보호모드 작동 중 ")
                    .bodyRegular14()
                    .foregroundStyle(.gray300)
            }
            
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
                .frame(height: 60)
                .background(.primaryNormal)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()
        }
        .onAppear {
            print("🏠 RecommendStartView 나타남 - path.count: \(router.path.count)")
         }
//        .navigationDestination(isPresented: $navigateToRecommend) {
//            RecommendView()
//                .environmentObject(stepManager)
//                .environmentObject(router)
//        }
        .background(Color.background)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}
