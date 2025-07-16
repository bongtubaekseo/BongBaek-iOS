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
                Text("\(event.hostInfo.hostName)님의 \(event.eventInfo.eventCategory)이")
                    .headBold26()
                    .foregroundStyle(.white)
                Text("\(event.eventInfo.dDay)일 남았어요!")
                    .headBold26()
                    .foregroundStyle(.white)
            }
            .padding(.top,40)
            
            Text("마음을 담은 봉투, 준비되셨나요?")
                .captionRegular12()
                .foregroundStyle(.gray100)
                .padding(.top, 8)
            
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
                    .frame(width: 14, height: 16)
                
                Text(event.eventInfo.eventDate)
                    .captionRegular12()
                    .foregroundColor(.white)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.gray750)
            .cornerRadius(6)
            .offset(y: -65)
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(
            LinearGradient(
                colors: gradientColors(for: event.eventInfo.eventCategory),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(width: 320, height: 260)
        .cornerRadius(10)
    }
    
    // 카테고리별 그라데이션 색상
    private func gradientColors(for category: String) -> [Color] {
        switch category {
        case "결혼식":
            return [
                Color(hex: "150857"),
                Color(hex: "5F57FF"),
                Color(hex: "7384FF"),
                Color(hex: "9EA5FF"),
                Color(hex: "CDCBFF"),
                Color(hex: "FFFFFF").opacity(0.8),
            ]
        case "생일":
            return [
                Color(hex: "150857"),
                Color(hex: "5F57FF"),
                Color(hex: "7384FF"),
                Color(hex: "9EA5FF"),
                Color(hex: "CDCBFF"),
                Color(hex: "FFFFFF").opacity(0.8),
            ]
        case "돌잔치":
            return [
                Color(hex: "150857"),
                Color(hex: "5F57FF"),
                Color(hex: "7384FF"),
                Color(hex: "9EA5FF"),
                Color(hex: "CDCBFF"),
                Color(hex: "FFFFFF").opacity(0.8),
            ]
        default:
            // 기본 (기존 보라 계열)
            return [
                Color(hex: "150857"),
                Color(hex: "5F57FF"),
                Color(hex: "7384FF"),
                Color(hex: "9EA5FF"),
                Color(hex: "CDCBFF"),
                Color(hex: "FFFFFF").opacity(0.8),
            ]
        }
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
