//
//  EmptyScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/12/25.
//
import SwiftUI

struct EmptyScheduleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("아직 예정된 일정이")
                    .headBold26()
                    .foregroundStyle(.white)
                Text("존재하지 않아요!")
                    .headBold26()
                    .foregroundStyle(.white)
            }
            .padding(.top,40)
            
            HStack {
                Spacer()
                Image("icon_BlackClock")
                    .resizable()
                    .frame(width: 134, height: 134)
                    .offset(y: -10)
            }
            .padding(.trailing, -10)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("일정추가하기 >")
                    .captionRegular12()
                    .foregroundColor(.gray300)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(.gray900)
            .cornerRadius(6)
            .offset(y: -65)
            

        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(.gray800)
        .frame(width: 320, height: 260)
        .cornerRadius(10)
    }
}

#Preview {
    EmptyScheduleView()
}
