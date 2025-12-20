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
                    Text("내 일정")
                        .font(.title_semibold_20)
                        .foregroundStyle(.txtDisplayPrimary)
                    Text("나의 경조사 일정을 관리해보세요!")
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtDisplayTierary)
                }
                Spacer()
                
                    Button(action: {
                        NotificationCenter.default.post(
                            name: .selectTab,
                            object: Tab.record
                        )
                    }) {
                        HStack(spacing: 0) {
                            Text("더보기")
                                .bodyRegular14()
                                .foregroundColor(.txtDisplaySecondary)

                            Image("icon_arrow")
                                .renderingMode(.template)
                                .foregroundColor(.txtDisplayTierary)
                                .frame(width: 14, height: 14)
                        }

                    }
            }
            .padding(.bottom, 20)
                
                if events.isEmpty {
                    EmptyCardView()
                } else {
                    LazyVStack(spacing: 12) {
                         ForEach(sortedEvents, id: \.eventId) { event in
                             NewScheduleCellView(event: event)
                         }
                     }
                }
            }
            .padding(.horizontal)
            .background(.bgDisplayPrimary)
        }
    }
