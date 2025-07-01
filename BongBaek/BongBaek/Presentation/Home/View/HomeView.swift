//
//  HomeView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//
import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ScheduleView(schedules: scheduleDummy)
                    .padding(.top, 48)
            }

            CustomTabView(selectedTab: $selectedTab)
                .background(Color.gray750)
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        topTrailingRadius: 10
                    )
                )
        }
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    HomeView()
}
