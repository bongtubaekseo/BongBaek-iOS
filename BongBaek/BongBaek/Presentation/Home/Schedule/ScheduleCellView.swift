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
            HStack(alignment: .top, spacing: 12) {
                Image(.iconAlarm)
                    .resizable()
                    .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(schedule.type)
                            .font(.caption_regular_12)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.gray750.opacity(0.9))
                            .foregroundColor(.primaryNormal)
                            .cornerRadius(4)

                        Text(schedule.relation)
                            .font(.caption_regular_12)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.gray750.opacity(0.9))
                            .foregroundColor(.primaryNormal)
                            .cornerRadius(4)
                    }

                    HStack {
                        Text(schedule.name)
                            .font(.title_semibold_18)
                            .foregroundColor(.white)

                        Spacer()

                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text(schedule.money.replacingOccurrences(of: "원", with: ""))
                                .font(.title_semibold_18)
                                .foregroundColor(.primaryNormal)

                            Text("원")
                                .font(.title_semibold_18)
                                .foregroundColor(.gray300)
                        }
                        .fixedSize()
                    }

                    HStack(spacing: 4) {
                        Image(.iconLocation)
                        Text(schedule.location)
                    }
                    .font(.caption_regular_12)
                    .foregroundColor(.gray300)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.3))
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 4) {
                        Image(.iconCalendar)
                        Text(schedule.date)
                    }
                    .font(.caption_regular_12)
                    .foregroundColor(.gray300)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.3))
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(.gray750)
            .cornerRadius(10)
        }
    }
}
