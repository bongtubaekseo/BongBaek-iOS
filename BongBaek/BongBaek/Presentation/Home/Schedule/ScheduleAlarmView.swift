//
//  ScheduleAlarmView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleAlarmView: View {
    let alarms: [ScheduleModel]
    @State private var currentIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(alarms.enumerated()).prefix(3), id: \.element.id) { index, schedule in
                        ScheduleIndicatorCellView(schedule: schedule)
                            .frame(width: UIScreen.main.bounds.width - 48)
                            .background(
                                GeometryReader { geo -> Color in
                                    let midX = geo.frame(in: .global).midX
                                    DispatchQueue.main.async {
                                        updateCurrentIndex(midX: midX, index: index)
                                    }
                                    return Color.clear
                                }
                            )
                    }
                }
                .padding(.horizontal, 16)
            }

            HStack(spacing: 6) {
                ForEach(0..<min(alarms.count, 3), id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.top, 12)
        }
    }

    private func updateCurrentIndex(midX: CGFloat, index: Int) {
        let screenCenterX = UIScreen.main.bounds.width / 2
        if abs(midX - screenCenterX) < 40 {
            if currentIndex != index {
                currentIndex = index
            }
        }
    }
}

#Preview {
    ScheduleAlarmView(alarms: scheduleDummy)
}
