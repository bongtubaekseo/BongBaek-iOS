//
//  EmptyScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/12/25.
//
import SwiftUI

struct EmptyScheduleView: View {
    @EnvironmentObject var router: NavigationRouter  
    
    var body: some View {
        Button(action: {
            router.push(to: .createEventViewAfterEvent)
        }) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("아직 예정된 일정이")
                        .headBold26()
                        .foregroundStyle(.white)
                    Text("존재하지 않아요")
                        .headBold26()
                        .foregroundStyle(.white)
                }
                .padding(.top,40)
                
                HStack {
                    Spacer()
                    Image("black_alarm_image")
                        .resizable()
                        .frame(width: 134, height: 134)
                        .offset(y: -10)
                }
                .padding(.trailing, -10)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("일정추가하기")
                        .captionRegular12()
                        .foregroundColor(.gray300)
                    
                    Image("icon_left")
                        .foregroundColor(.gray400)
                        .frame(width: 3, height: 8)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.gray900)
                .cornerRadius(6)
                .offset(y: -55)
            }
            .padding(.top, 40)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            .background(.gray800)
            .frame(maxWidth: .infinity, maxHeight: 260)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
        .contentShape(Rectangle())        // 전체 영역 터치 가능
    }
}

#Preview {
    EmptyScheduleView()
}
