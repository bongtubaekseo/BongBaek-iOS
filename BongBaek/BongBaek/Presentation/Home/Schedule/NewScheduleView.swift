//
//  NewScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/17/25.
//
import SwiftUI

enum EventCategory: String {
    case wedding = "결혼"
    case birthday = "생일"
    case stoneparty = "돌잔치"
    case funeral = "장례식"
    
    var iconImage: String {
        switch self {
        case .wedding:
            return "icon_marriage"
        case .birthday:
            return "icon_birthday 1"
        case .stoneparty:
            return "icon_stoneparty"
        case .funeral:
            return "icon_funeral"
        }
    }
}

struct NewScheduleView: View {
    let event: Event?

    var body: some View {
        if let event = event {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("경조사 알림")
                            .font(.caption_regular_12)
                            .foregroundColor(.txtDisplaySubtle)

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

                    HStack(spacing: 4) {
                        Image(.iconCalendar)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.iconDisabledPrimary)

                        Text(event.eventInfo.eventDate.DateFormat())
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

                Image(getCategoryIcon(for: event))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 94, height: 82)
                    .padding(.trailing, 12)
            }
            .padding(.vertical, 10)
            .background(.bgDisplaySecondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderFieldDefault, lineWidth: 1)
            )
            .padding(.horizontal, 20)
        } else {
            EmptyNewScheduleView()
        }
    }
    
    private func getCategoryIcon(for event: Event) -> String {
        EventCategory(rawValue: event.eventInfo.eventCategory)?.iconImage ?? "icon_alarm"
    }
}
