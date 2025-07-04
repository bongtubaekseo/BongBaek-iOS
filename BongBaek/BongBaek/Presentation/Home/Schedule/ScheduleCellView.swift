//
//  ScheduleCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleCellView: View {
    let schedule: ScheduleModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nickname")
                .font(.caption_regular_12)
                .foregroundColor(.primaryNormal)

            HStack {
                Text(schedule.name)
                    .titleSemiBold18()
                    .foregroundColor(.white)

                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(schedule.money.replacingOccurrences(of: "원", with: ""))
                        .titleSemiBold18()
                        .foregroundColor(.white)

                    Text("원")
                        .titleSemiBold18()
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            // 태그들
            HStack(spacing: 6) {
                Text(schedule.type)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.gray750.opacity(0.1))
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)

                Text(schedule.relation)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.gray750.opacity(0.1))
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)
            }

            HStack(spacing: 4) {
                Image(.iconLocation)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(schedule.location)
            }
            .font(.caption_regular_12)
            .foregroundColor(.gray300)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(height: 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black.opacity(0.3))
            .cornerRadius(4)

            HStack(spacing: 4) {
                Image(.iconCalendar)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(schedule.date)
            }
            .font(.caption_regular_12)
            .foregroundColor(.gray300)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(height: 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black.opacity(0.3))
            .cornerRadius(4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(.gray750)
        .cornerRadius(10)
    }
}
