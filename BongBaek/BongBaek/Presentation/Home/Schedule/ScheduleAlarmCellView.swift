//
//  ScheduleAlarmCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleIndicatorCellView: View {
    let event: Event
    

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading) {
                if event.eventInfo.dDay == 0 {
                    Text("오늘은 \(event.hostInfo.hostName)님의")
                        .headBold26()
                        .foregroundStyle(.white)
                    Text("\(event.eventInfo.eventCategory)입니다!")
                        .headBold26()
                        .foregroundStyle(.white)
                } else {
                    Text("\(event.hostInfo.hostName)님의 \(event.eventInfo.eventCategory)이")
                        .headBold26()
                        .foregroundStyle(.white)
                    Text("\(event.eventInfo.dDay)일 남았어요!")
                        .headBold26()
                        .foregroundStyle(.white)
                }
            }
            .padding(.top,40)
            
            Text("마음을 담은 봉투, 준비되셨나요?")
                .captionRegular12()
                .foregroundStyle(.gray100)
                .padding(.top, 10)
            
            HStack {
                Spacer()
                Image(.iconClock)
                    .resizable()
                    .frame(width: 136, height: 136)
                    .offset(y: -20)
            }
            .padding(.trailing, -10)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(.iconCalendar)
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text(event.eventInfo.eventDate)
                    font(.caption_regular_12)
                    .foregroundColor(.gray100)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.gray750)
            .cornerRadius(4)
            .offset(y: -65)
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "150857"), location: 0.15),
                    .init(color: Color(hex: "5F57FF"), location: 0.35),
                    .init(color: Color(hex: "7384FF"), location: 0.55),
                    .init(color: Color(hex: "9EA5FF"), location: 0.70),
                    .init(color: Color(hex: "CDCBFF"), location: 0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(height: 260)
        .cornerRadius(10)
    }
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
