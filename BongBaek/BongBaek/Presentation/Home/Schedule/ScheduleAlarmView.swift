//
//  ScheduleAlarmView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleAlarmView: View {
    let alarms: [ScheduleModel]
    @State private var selectedIndex = 0

    var body: some View {
        VStack(spacing: 1) {
            TabView(selection: $selectedIndex) {
                ForEach(Array(alarms.enumerated()).filter { $0.offset < 3 }, id: \.element.id) { index, schedule in
                    ScheduleIndicatorCellView(schedule: schedule)
                        .tag(index)
                        .padding(.horizontal, 8)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .padding(.bottom, 12)
    }
}


#Preview {
    ScheduleAlarmView(alarms: scheduleDummy)
}
