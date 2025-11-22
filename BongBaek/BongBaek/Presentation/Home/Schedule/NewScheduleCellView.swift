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
            .frame(width: 60)
            
            Rectangle()
                .fill(Color.borderDisplayDivider)
                .frame(width: 1)
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text(event.hostInfo.hostName)
                        .font(.body1_medium_16)
                        .foregroundColor(.txtDisplayPrimary)
                    
                    Text("·")
                        .foregroundColor(.txtDisplaySecondary)
                    
                    Text(event.eventInfo.eventCategory)
                        .font(.body2_regular_14)
                        .foregroundColor(.txtDisplaySubtle)
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image("icon_newcalendar1")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.eventInfo.eventDate.DateFormat())
                            .font(.caption_regular_12)
                            .foregroundColor(.txtDisplayTierary)
                    }
                    
                    HStack(spacing: 4) {
                        Image("icon_newlocation")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text({
                            let location = event.locationInfo.location
                            if location == "미정" || location.isEmpty {
                                return "-"
                            }
                            return location
                        }())
                        .font(.caption_regular_12)
                        .foregroundColor(.txtDisplayTierary)
                        .lineLimit(1)
                    }
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image("icon_newrelation")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.eventInfo.relationship)
                            .font(.caption_regular_12)
                            .foregroundColor(.txtDisplayTierary)
                    }
                    
                    
                    HStack(spacing: 4) {
                        Image("icon_nickname")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(event.hostInfo.hostNickname)
                            .font(.caption_regular_12)
                            .foregroundColor(.txtDisplayTierary)
                    }
                }
            }
            
            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(event.eventInfo.cost.formatted())")
                    .titleSemiBold16()
                    .foregroundColor(.txtDisplayPrimary)

                Text("원")
                    .bodyMedium16()
                    .foregroundColor(.txtDisplayPrimary)
            }
        }
        .padding(16)
        .background(.bgDisplayCard)
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
