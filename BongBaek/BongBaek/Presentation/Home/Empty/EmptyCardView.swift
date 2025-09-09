//
//  EmptyCardView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/12/25.
//

import SwiftUI

struct EmptyCardView: View {
    @EnvironmentObject var router: NavigationRouter  
    
    var body: some View {
        Button(action: {
            router.push(to: .createEventViewAfterEvent)
        }) {
            VStack(spacing: 20) {
                VStack {
                    Image("icon_plus")
                        .foregroundColor(.black)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(Color(hex:"#6E7FFF")))
                }
                .padding(.top, 14)

                Text("예정된 일정이 없습니다")
                    .titleSemiBold18()
                    .foregroundColor(.white)
                    .padding(.bottom, -12)
                   

                HStack(spacing: 4) {
                    Text("일정추가하기")
                        .captionRegular12()
                        .foregroundColor(.gray300)
                    
                    Image("icon_left")
                        .foregroundColor(.gray400)
                        .frame(width: 5, height: 10)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.gray900)
                .cornerRadius(6)
                .padding(.bottom, 14)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray800)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
        .contentShape(Rectangle())        // 전체 영역 터치 가능
    }
}

