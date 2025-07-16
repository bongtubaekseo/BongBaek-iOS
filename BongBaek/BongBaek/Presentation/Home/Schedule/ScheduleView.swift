//
//  ScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//

import SwiftUI

struct ScheduleView: View {
    let events: [Event]
    @EnvironmentObject var router: NavigationRouter
    
    private var sortedEvents: [Event] {
           return events.sorted { $0.eventInfo.dDay < $1.eventInfo.dDay }
       }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("봉백님의 일정")
                    .font(.title_semibold_20)
                    .foregroundStyle(.white)
                
                Spacer()

                    Button(action: {
                        router.push(to: .fullScheduleView)
                    }) {
                        Text("더보기")
                            .bodyRegular14()
                            .foregroundColor(.gray)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.clear)
                }
            }
            .padding(.bottom, 20)
            
            if events.isEmpty {
                EmptyCardView()
            } else {
                
                ForEach(sortedEvents, id: \.eventId) { event in
                    Button(action: {
                        router.push(to: .allRecordView(eventId: event.eventId))
                    }) {
                        ScheduleCellView(event: event)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
        .background(Color.black)
    }
}
