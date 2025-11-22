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
           return events.sorted { $0.eventInfo.dDay > $1.eventInfo.dDay }
       }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2){
                    Text("\(UserDefaults.standard.memberName.isEmpty ? "봉백" : UserDefaults.standard.memberName)님의 일정")
                        .font(.title_semibold_20)
                        .foregroundStyle(.txtDisplayPrimary)
                    Text("나의 경조사 일정을 관리해보세요!")
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtDisplayTierary)
                }
                Spacer()

                if !events.isEmpty {
                    Button(action: {
                        router.push(to: .fullScheduleView)
                    }) {
                        HStack(spacing: 4) {
                            Text("더보기")
                                .bodyRegular14()
                                .foregroundColor(.txtDisplaySecondary)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            
            if events.isEmpty {
                EmptyCardView()
            } else {
                ForEach(sortedEvents, id: \.eventId) { event in
                    NewScheduleCellView(event: event)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.gray900)
    }
}
