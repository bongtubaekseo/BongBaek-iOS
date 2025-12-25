//
//  NewScheduleCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/18/25.
//

import SwiftUI

struct NewScheduleCellView: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("\(extractDay(from: event.eventInfo.eventDate))")
                    .font(.title_semibold_18)
                    .foregroundColor(.txtDisplayPrimary)
                
                Text("일")
                    .font(.caption_regular_12)
                    .foregroundColor(.txtDisplaySecondary)
            }
            .frame(width: 29)
            .padding(.bottom, 25)
            
            Rectangle()
                .fill(.borderFieldDefault)
                .frame(width: 1,height: 70)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text(event.hostInfo.hostName)
                        .bodyMedium16()
                        .foregroundColor(.txtDisplayPrimary)
                    
                    Text("·")
                        .foregroundColor(.txtDisplaySecondary)
                    
                    Text(event.eventInfo.eventCategory)
                        .bodyMedium16()
                        .foregroundColor(.txtDisplaySubtle)
                    
                    Spacer(minLength: 0)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(event.eventInfo.cost.formatted())")
                            .titleSemiBold16()
                            .foregroundColor(.txtDisplayPrimary)

                        Text("원")
                            .bodyMedium16()
                            .foregroundColor(.txtDisplayPrimary)
                    }
                    //.padding(.trailing, 16)
                    
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image("icon_calendar_off")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.eventInfo.eventDate.DateFormat())
                            .captionRegular12()
                            .foregroundColor(.txtDisplayTierary)
                    }
                    
                    Rectangle()
                        .fill(.borderFieldDefault)
                        .frame(width: 1)
                    
                    HStack(spacing: 4) {
                        Image("icon_eventLocation_off")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text({
                            let location = event.locationInfo.location
                            if location == "미정" || location.isEmpty {
                                return "-"
                            }
                            return location
                        }())
                        .captionRegular12()
                        .foregroundColor(.txtDisplayTierary)
                        .lineLimit(1)
                    }
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image("icon_relation_off")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.eventInfo.relationship)
                            .captionRegular12()
                            .foregroundColor(.txtDisplayTierary)
                    }
                    
                    Rectangle()
                        .fill(.borderFieldDefault)
                        .frame(width: 1)
                    
                    HStack(spacing: 4) {
                        Image("icon_nickname_off")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.hostInfo.hostNickname)
                            .captionRegular12()
                            .foregroundColor(.txtDisplayTierary)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.btnInteractiveSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func extractDay(from dateString: String) -> String {
        let components = dateString.split(separator: "-")
        if components.count >= 3 {
            return String(components[2])
        }
        return ""
    }
}
