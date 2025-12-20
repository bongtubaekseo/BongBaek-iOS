//
//  EmptyNewScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/27/25.
//
import SwiftUI

struct EmptyNewScheduleView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("경조사 알림")
                        .captionRegular12()
                        .foregroundColor(.txtDisplaySubtle)

                    Text("다가오는 경조사가 없어요")
                        .titleSemiBold16()
                        .foregroundColor(.txtDisplayPrimary)
                }

                HStack(spacing: 4) {
                    Image("empty_calender")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 14, height: 14)
                        .padding(.leading, -2)

                    Text("아직 예정된 일정이 없습니다")
                        .captionRegular12()
                        .foregroundColor(.txtDisplaySecondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(.bgDisplayPrimary)
                .cornerRadius(2)
            }
            .padding(.leading, 16)
            
            Spacer()
        }
        .padding(.vertical, 14)
        .frame(height: 102)
        .background(.bgDisplaySecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderFieldDefault, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
