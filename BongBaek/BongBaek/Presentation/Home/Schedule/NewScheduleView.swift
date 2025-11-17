//
//  NewScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/17/25.
//
import SwiftUI

struct NewScheduleView: View{
    let event : Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text("경조사 알림")
                        .font(.caption_regular_12)
                        .foregroundColor(.txtDisplaySubtle)
                    
                    if event.eventInfo.dDay == 0 {
                        Text("오늘은 \(event.hostInfo.hostName)님의")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                        Text("\(event.eventInfo.eventCategory)입니다!")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                    } else {
                        Text("\(event.hostInfo.hostName)님의 \(event.eventInfo.eventCategory)이")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                        Text("\(event.eventInfo.dDay)일 남았어요!")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplayPrimary)
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
}
