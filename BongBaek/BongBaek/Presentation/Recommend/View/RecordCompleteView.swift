//
//  RecordCompleteView.swift
//  BongBaek
//
//  Created by 임재현 on 7/6/25.
//

import SwiftUI

struct RecordCompleteView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("기록완료")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                Spacer()
            }
            
            LottieView(animationFileName: "success", loopMode: .playOnce)
                .frame(width: 270, height: 256)
            
            
            
            VStack(alignment: .center) {
                Text("기록이 완료됐어요!")
                    .headBold26()
                    .foregroundStyle(.white)
                
                Text("경조사 기록이 저장되었습니다")
                    .bodyRegular14()
                    .foregroundStyle(.gray400)
                    .padding(.top, 20)
                
                Text("[기록하기] 확인하실 수 있어요")
                    .bodyRegular14()
                    .foregroundStyle(.gray400)
            }
            .padding(.top,50)
            
            VStack(spacing: 10) {
                NavigationLink(destination: HomeView()) {
                    Text("홈으로 가기")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.primaryNormal)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: LoginView()) {
                    Text("내 기록보기")
                        .titleSemiBold18()
                        .foregroundStyle(.gray100)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.gray700)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.primaryNormal, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)

            Spacer()
        }
        .background(Color.background)

    }
}

#Preview {
    RecordCompleteView()
}
