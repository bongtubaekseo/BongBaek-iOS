//
//  HomeView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//
import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var stepManager = GlobalStepManager()
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HStack {
                    Image(.logoSymbol)
                        .frame(width: 20, height: 20)
                    
                    Text("봉투백서")
                        .brandBold18()
                        .foregroundColor(.txtDisplayPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
                .padding(.leading, 20)

                if homeViewModel.hasData,
                   let firstEvent = homeViewModel.homeData?.events.first {
                    NewScheduleView(event: firstEvent)
                        .padding(.top, 20)
                } else if homeViewModel.isLoading {
                    VStack {
                        ProgressView("일정을 불러오는 중…")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }
                
                if homeViewModel.hasData {
                    ScheduleView(events: homeViewModel.homeData?.events ?? [])
                        .padding(.top, 32)
                        .padding(.bottom, 60)
                } else {

                    ScheduleView(events: [])
                        .padding(.top, 32)
                        .padding(.bottom, 60)
                }
                
//                if homeViewModel.hasData {
//                    ScheduleAlarmView(homeData: $homeViewModel.homeData)
//                        .frame(height: 276)
//                        .padding(.top, 30)
//                } else if homeViewModel.isLoading {
//                    // 로딩 중일 때 ScheduleAlarmView 자리
//                    VStack {
//                        ProgressView("일정을 불러오는 중…")
//                            .foregroundColor(.white)
//                    }
//                    .frame(height: 276)
//                    .padding(.top, 30)
//                } else {
//                    // 데이터가 없거나 에러일 때 더미 데이터 또는 빈 뷰
//                    ScheduleAlarmView(homeData: .constant(nil))
//                        .frame(height: 276)
//                        .padding(.top, 30)
//                }
        
                if homeViewModel.hasData {
                    RecommendsView(homeData: homeViewModel.homeData)
                            .environmentObject(stepManager)
                        .environmentObject(router)
                        .padding(.top, 32)
                } else {
                    RecommendsView(homeData: nil)
                        .environmentObject(stepManager)
                        .environmentObject(router)
                        .padding(.top, 32)
                }
                
                HomeContentsView()
                
            }
        }
        .onAppear {
            print("HomeView 나타남 - 데이터 로드 시작")
            homeViewModel.loadData()
        }
        .refreshable {
            print("HomeView 새로고침")
            homeViewModel.refreshData()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .background(Color.gray900.ignoresSafeArea())
    }
}

