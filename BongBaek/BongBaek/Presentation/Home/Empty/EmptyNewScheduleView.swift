//
//  EmptyNewScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/27/25.
//
import SwiftUI

struct EmptyNewScheduleView: View {
    @EnvironmentObject var router : NavigationRouter
    let event : Event
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("경조사 알림")
                        .font(.caption_regular_12)
                        .foregroundColor(.txtDisplaySubtle)

                    Text("다가오는 경조사가 없어요")
                        .font(.title_semibold_16)
                        .foregroundColor(.txtDisplayPrimary)
                }

                HStack(spacing: 4) {
                    Image(.iconCalendar)
                        .resizable()
                        .frame(width: 14, height: 14)

                    Text("아직 예정된 일정이 없습니다")
                        .font(.caption_regular_12)
                        .foregroundColor(.txtDisplaySecondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.bgDisplayPrimary)
                .cornerRadius(2)
            }
            .padding(.leading, 16)
            
            Spacer()
            
        }
        .padding(.vertical, 10)
        .background(.bgDisplaySecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderFieldDefault, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
