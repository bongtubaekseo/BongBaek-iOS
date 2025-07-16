//
//  ScheduleAlarmView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct ScheduleAlarmView: View {
    @Binding var homeData: EventHomeData?
    @State private var currentIndex: Int = 0

    
    private var sortedEvents: [Event] {
        let events = homeData?.events ?? []
        return events.sorted { $0.eventInfo.dDay < $1.eventInfo.dDay }
    }

    @State private var scrollOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0

    private let cardSpacing: CGFloat = 8
    private let cardWidth: CGFloat = UIScreen.main.bounds.width - 40
    private let sidePadding: CGFloat = 16


    var body: some View {
        VStack(spacing: 0) {
            if sortedEvents.isEmpty {
                EmptyScheduleView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(sortedEvents.enumerated()).prefix(3), id: \.element.eventId) { index, event in
                            ScheduleIndicatorCellView(event: event)
                                .frame(width: cardWidth)
                                .background(
                                    GeometryReader { geo -> Color in
                                        let midX = geo.frame(in: .global).midX
                                        DispatchQueue.main.async {
                                            updateCurrentIndex(
                                                midX: midX,
                                                index: index
                                            )
                                        }
                                        return Color.clear
                                    }
                                )
                        }
                    }
                    .padding(.horizontal, sidePadding)
                    .offset(x: scrollOffset + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let totalOffset =
                                    scrollOffset + value.translation.width
                                let cardWithSpacing = cardWidth + cardSpacing
                                let rawIndex = -totalOffset / cardWithSpacing
                                let newIndex = max(
                                    0,
                                    min(2, Int((rawIndex).rounded()))
                                )

                                withAnimation(.easeOut) {
                                    currentIndex = newIndex
                                    scrollOffset =
                                        -CGFloat(newIndex) * cardWithSpacing
                                    dragOffset = 0
                                }
                            }
                    )
                }
                .frame(height: 260)

                HStack(spacing: 6) {
                    ForEach(0..<min(sortedEvents.count, 3), id: \.self) { index in
                        Circle()
                            .fill(
                                index == currentIndex
                                    ? Color.white : Color.gray.opacity(0.5)
                            )
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.top, 12)
            }
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

