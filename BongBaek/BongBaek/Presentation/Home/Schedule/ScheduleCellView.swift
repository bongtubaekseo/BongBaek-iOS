//
//  ScheduleCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

//struct ScheduleCellView: View {
//    let events: EventHomeData
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Nickname")
//                .font(.caption_regular_12)
//                .foregroundColor(.primaryNormal)
//
//            HStack {
//                Text(schedule.name)
//                    .titleSemiBold18()
//                    .foregroundColor(.white)
//
//                Spacer()
//
//                HStack(alignment: .firstTextBaseline, spacing: 0) {
//                    Text(schedule.money.replacingOccurrences(of: "원", with: ""))
//                        .titleSemiBold18()
//                        .foregroundColor(.white)
//
//                    Text("원")
//                        .titleSemiBold18()
//                        .foregroundColor(.white.opacity(0.8))
//                }
//            }
//
//            HStack(spacing: 6) {
//                Text(schedule.type)
//                    .captionRegular12()
//                    .padding(.horizontal, 6)
//                    .padding(.vertical, 2)
//                    .background(.gray750.opacity(0.1))
//                    .foregroundColor(.primaryNormal)
//                    .cornerRadius(4)
//
//                Text(schedule.relation)
//                    .captionRegular12()
//                    .padding(.horizontal, 6)
//                    .padding(.vertical, 2)
//                    .background(.gray750.opacity(0.1))
//                    .foregroundColor(.primaryNormal)
//                    .cornerRadius(4)
//            }
//
//            HStack(spacing: 4) {
//                Image(.iconLocation)
//                    .resizable()
//                    .frame(width: 16, height: 16)
//                Text(schedule.location)
//                    .captionRegular12()
//                    .foregroundColor(.gray200)
//            }
//            .padding(.horizontal, 8)
//            .padding(.vertical, 6)
//            .frame(height: 28)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(.black.opacity(0.3))
//            .cornerRadius(4)
//
//            HStack(spacing: 4) {
//                Image(.iconCalendar)
//                    .resizable()
//                    .frame(width: 16, height: 16)
//                Text(schedule.date)
//            }
//            .font(.caption_regular_12)
//            .foregroundColor(.gray200)
//            .padding(.horizontal, 8)
//            .padding(.vertical, 6)
//            .frame(height: 28)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(.black.opacity(0.3))
//            .cornerRadius(4)
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 18)
//        .background(.gray750)
//        .cornerRadius(10)
//    }
//}

struct ScheduleCellView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(event.hostInfo.hostNickname)
                .font(.caption_regular_12)
                .foregroundColor(.primaryNormal)

            HStack {
                Text(event.hostInfo.hostName)
                    .titleSemiBold18()
                    .foregroundColor(.white)

                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(event.eventInfo.cost.formatted())")
                        .titleSemiBold18()
                        .foregroundColor(.white)

                    Text("원")
                        .titleSemiBold18()
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            HStack(spacing: 6) {
                Text(event.eventInfo.eventCategory)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.gray750.opacity(0.1))
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)

                Text(event.eventInfo.relationship)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.gray750.opacity(0.1))
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)
                
                // D-Day 표시 추가
                Text("D-\(event.eventInfo.dDay)")
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.primaryNormal.opacity(0.2))
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)
            }

            HStack(spacing: 4) {
                Image(.iconLocation)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(event.locationInfo.location)
                    .captionRegular12()
                    .foregroundColor(.gray200)
            }
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
                Text(event.eventInfo.eventDate)
            }
            .font(.caption_regular_12)
            .foregroundColor(.gray200)
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
