//
//  ScheduleAlarmCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleIndicatorCellView: View {
    let schedule: ScheduleModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading) {
                Text("\(schedule.name)님의 \(schedule.type)이")
                    .headBold26()
                    .foregroundStyle(.white)
                Text("\(dDay(from: schedule.date))일 남았어요!")
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
                
                Text(schedule.date)
                    .font(.caption_regular_12)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.black)
            .cornerRadius(6)
            .offset(y: -65)
            

        }
//        .frame(width: 320, height: 260)
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "150857"),
                    Color(hex: "5F57FF"),
                    Color(hex: "7384FF"),
                    Color(hex: "9EA5FF"),
                    Color(hex: "CDCBFF"),
                    Color(hex: "FFFFFF").opacity(0.8),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(width: 320, height: 260)
        .cornerRadius(10)
    }

    func dDay(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(E)"
        if let targetDate = formatter.date(from: dateString) {
            let diff = Calendar.current.dateComponents(
                [.day],
                from: Date(),
                to: targetDate
            )
            return diff.day ?? 0
        }
        return 0
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
