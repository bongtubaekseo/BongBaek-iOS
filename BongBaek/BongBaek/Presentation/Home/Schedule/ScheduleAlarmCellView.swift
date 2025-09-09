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
                    .padding(.leading, 8)
                
                Text(formatDate(event.eventInfo.eventDate))
                    .font(.caption_regular_12)
                    .foregroundColor(.gray100)
            }
            .padding(.vertical, 4)
            .padding(.trailing, 10)
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

public func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy년 MM월 dd일"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    
    return dateString // 변환 실패 시 원본 반환
}
