//
//  NewScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/17/25.
//
import SwiftUI

struct NewScheduleView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("경조사 알림")
                        .font(.caption_regular_12)
                        .foregroundColor(.txtDisplaySubtle)
                        .padding(.top, 6)

                    if event.eventInfo.dDay == 0 {
                        Text("오늘은 \(event.hostInfo.hostName)님의 \(event.eventInfo.eventCategory)입니다!")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                            .lineLimit(2)
                    } else {
                        Text("\(event.hostInfo.hostName)님의 \(event.eventInfo.eventCategory)이 \(event.eventInfo.dDay)일 남았어요!")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                            .lineLimit(2)
                    }
                }

                Spacer()

                Image("icon_alarm")
                    .resizable()
                    .frame(width: 94, height: 82)
            }

            HStack(spacing: 4) {
                Image(.iconCalendar)
                    .resizable()
                    .frame(width: 14, height: 14)

                Text(event.eventInfo.eventDate.DateFormat())
                    .font(.caption_regular_12)
                    .foregroundColor(.gray100)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.bgDisplayPrimary)
            .cornerRadius(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.bgDisplaySecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderFieldDefault, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
