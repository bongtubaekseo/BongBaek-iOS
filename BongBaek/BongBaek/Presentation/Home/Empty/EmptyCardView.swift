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
//            router.push(to: .createEventViewAfterEvent)
            router.push(to: .createEventView)
        }) {
            VStack(spacing: 20) {
                VStack {
                    Image("icon_plus")
                        .frame(width: 24, height: 24)
                        
                }
                .padding(.top, 14)

                Text("예정된 일정이 없습니다")
                    .bodyMedium14()
                    .foregroundColor(.txtDisplaySecondary)
                    .padding(.bottom, -12)
                   

                HStack(spacing: 4) {
                    Text("일정 추가하기")
                        .captionRegular12()
                        .foregroundColor(.txtDisplayTierary)
                    
                    Image("icon_left")
                        .foregroundColor(.iconDisabledSecondary)
                        .frame(width: 5, height: 10)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.bgDisplayPrimary)
                .cornerRadius(6)
                .padding(.bottom, 14)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.bgFieldPrimary)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
        .contentShape(Rectangle())        // 전체 영역 터치 가능
    }
}

