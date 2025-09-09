//
//  ScheduleCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI


struct ScheduleCellView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(event.hostInfo.hostNickname)
                .captionRegular12()
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
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.primaryBg)
                    .foregroundColor(.primaryNormal)
                
                    .cornerRadius(4)

                Text(event.eventInfo.relationship)
                    .captionRegular12()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.primaryBg)
                    .foregroundColor(.primaryNormal)
                    .cornerRadius(4)
                
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image("carbon_location-filled")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(event.locationInfo.location)
                        .captionRegular12()
                        .foregroundColor(.gray200)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .frame(height: 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray800)
                .cornerRadius(4)

                HStack(spacing: 8) {
                    Image("icon_calendar")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(event.eventInfo.eventDate)
                }
                .font(.caption_regular_12)
                .foregroundColor(.gray200)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .frame(height: 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray800)
                .cornerRadius(4)
            }

         
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(.gray750)
        .cornerRadius(10)
    }
}
