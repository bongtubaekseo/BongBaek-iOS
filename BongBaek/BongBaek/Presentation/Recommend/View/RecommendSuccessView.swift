//
//  RecommendSuccessView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/8/25.
//

import SwiftUI

struct RecommendSuccessView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var eventManager: EventCreationManager
    
    var body: some View {
            ZStack {
                Color.gray900
                    .ignoresSafeArea(.all)
                VStack(spacing: 0) {

                    HStack {
                        Text("기록 완료")
                            .titleSemiBold18()
                            .foregroundStyle(.white)
                    }
                    
                    
                    VStack(spacing: 20) {
                        Spacer()
                        LottieView(animationFileName: "success", loopMode: .playOnce)
                            .frame(width: 270, height: 256)
                        
                        Text("기록이 완료됐어요!")
                            .headBold26()
                            .foregroundColor(.white)
                                        
                        Text("경조사 기록이 저장되었습니다.\n[기록하기]에서 확인할 수 있어요.")
                            .bodyRegular14()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray400)
                        
                        VStack(spacing: 10) {
                            Button(action: {
                                print("홈으로 가기 버튼 클릭됨")
                                eventManager.resetAllData()
                                   print("pathManager.path.count: \(router.path.count)")
                                router.popToRootAndSelectTab(.home)
                                   print("popToRootAndSelectTab 호출 완료")
                            }) {
                                Text("홈으로 가기")
                                    .titleSemiBold18()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(.primaryNormal)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                router.popToRootAndSelectTab(.record)
                                eventManager.resetAllData()
                            }) {
                                Text("내 기록 보기")
                                    .titleSemiBold18()
                                    .foregroundColor(.gray100)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(Color.gray700)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 70)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                print("⏳ RecommendSuccessView 나타남 - path.count: \(router.path.count)")
            }
        .navigationBarHidden(true)
    }
}

#Preview {
    RecommendSuccessView()
}
