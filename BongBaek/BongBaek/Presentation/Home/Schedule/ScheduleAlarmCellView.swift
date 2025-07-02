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
        VStack(alignment: .leading, spacing: 12) {
            // 상단 문구
            Text("\(schedule.name)님의 \(schedule.type)이 \(dDay(from: schedule.date))일 남았어요!")
                .font(.title_semibold_16)
                .foregroundColor(.white)

            // 이미지 자리
            Rectangle()
                .fill(Color.gray)
                .frame(width: 135, height: 120)
                .cornerRadius(6)

            // 날짜 정보
            HStack(spacing: 4) {
                Image(.iconCalendar)
                    .resizable()
                    .frame(width: 14, height: 16)

                Text(schedule.date)
                    .font(.caption_regular_12)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray750)
            .cornerRadius(6)
        }
        .padding()
        .background(.primaryNormal) // 그라데이션 또는 컬러 이름 가능
        .cornerRadius(12)
    }

    // D-Day 계산
    func dDay(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(E)" // 날짜 형식 맞춰줘야 함
        if let targetDate = formatter.date(from: dateString) {
            let diff = Calendar.current.dateComponents([.day], from: Date(), to: targetDate)
            return diff.day ?? 0
        }
        return 0
    }
}
