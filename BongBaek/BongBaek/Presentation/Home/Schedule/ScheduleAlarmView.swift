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
    private let sidePadding: CGFloat = 20
    
    
    private var cardWidth: CGFloat {
            let screenWidth = UIScreen.main.bounds.width
            if sortedEvents.count <= 1 {
                return screenWidth - 40
            } else {
                return screenWidth - sidePadding - 20
                
            }
        }

    var body: some View {
        VStack(spacing: 0) {
            if sortedEvents.isEmpty {
                EmptyScheduleView()
                    .padding(.horizontal, 20)
            } else {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: cardSpacing) {
                            ForEach(
                                Array(sortedEvents.enumerated()).prefix(3),
                                id: \.element.eventId
                            ) { index, event in
                                ScheduleIndicatorCellView(event: event)
                                    .frame(width: cardWidth)
                                    .background(
                                        GeometryReader { geo -> Color in
                                            let midX = geo.frame(in: .global)
                                                .midX
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
                        .padding(.leading, sidePadding)
                        .padding(.trailing, 20)
                        .offset(x: scrollOffset + dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let totalOffset =
                                    scrollOffset + value.translation.width
                                    let cardWithSpacing =
                                    cardWidth + cardSpacing
                                    let rawIndex =
                                    -totalOffset / cardWithSpacing
                                    let maxIndex = min(
                                        sortedEvents.count - 1,
                                        2
                                    )
                                    let newIndex = max(
                                        0,
                                        min(maxIndex, Int(rawIndex.rounded()))
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
                    .clipped()
                }
                .frame(height: 260)
                
                if min(sortedEvents.count, 3) > 1 {
                    HStack(spacing: 6) {
                        ForEach(0..<min(sortedEvents.count, 3), id: \.self) {
                            index in
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
        .onChange(of: sortedEvents.count) { oldValue, newValue in
            if currentIndex >= newValue {
                withAnimation(.easeOut) {
                    currentIndex = 0
                    scrollOffset = 0
                    dragOffset = 0
                }
            }
        }
        .onAppear {
            currentIndex = 0
            scrollOffset = 0
            dragOffset = 0
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
