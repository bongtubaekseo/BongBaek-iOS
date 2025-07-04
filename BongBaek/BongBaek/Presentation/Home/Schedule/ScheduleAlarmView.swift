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
        VStack(spacing: 0) {
            TabView(selection: $selectedIndex) {
                ForEach(Array(alarms.enumerated()).prefix(3), id: \.element.id) { index, schedule in
                    ScheduleIndicatorCellView(schedule: schedule)
                        .tag(index)
                        .padding(.horizontal, 8)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))

            HStack(spacing: 6) {
                ForEach(0..<min(alarms.count, 3), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.top, 12) // Cell과 충분히 떨어지도록 조정
        }
    }
}




#Preview {
    ScheduleAlarmView(alarms: scheduleDummy)
}
