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
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    HStack {
                        Text("봉투백서")
                            .font(.head_bold_24)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    ScheduleAlarmView(alarms: scheduleDummy)
                        .frame(height: 276)
                        .padding(.top, 30)
                    RecommendsView()
                        .padding(.top, 10)
                    ScheduleView(schedules: scheduleDummy)
                        .padding(.top, 32)
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
}

#Preview {
    HomeView()
}
