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
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HStack {
                    Text("봉투백서")
                        .font(.head_bold_24)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    
                    Image(.homeLogo)
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            router.push(to : .MyPageView)
                        }
                }
                .padding(.top, 30)

                
                if homeViewModel.hasData {
                    ScheduleAlarmView(homeData: $homeViewModel.homeData)
                        .frame(height: 276)
                        .padding(.top, 30)
                } else if homeViewModel.isLoading {
                    // 로딩 중일 때 ScheduleAlarmView 자리
                    VStack {
                        ProgressView("일정을 불러오는 중…")
                            .foregroundColor(.white)
                    }
                    .frame(height: 276)
                    .padding(.top, 30)
                } else {
                    // 데이터가 없거나 에러일 때 더미 데이터 또는 빈 뷰
                    ScheduleAlarmView(homeData: .constant(nil))
                        .frame(height: 276)
                        .padding(.top, 30)
                }
            
                Button("로그아웃 테스트") {
//                    AuthManager.shared.logout()
//                    KeychainManager.shared.printTokenStatus()
                    
                    router.push(to: .accountDeletionView)
                }
                .foregroundColor(.red)

                if homeViewModel.hasData {
                    RecommendsView(homeData: homeViewModel.homeData)
                            .environmentObject(stepManager)
                        .environmentObject(router)
                        .padding(.top, 10)
                } else {
                    RecommendsView(homeData: nil)
                        .environmentObject(stepManager)
                        .environmentObject(router)
                        .padding(.top, 10)
                }
                
                if homeViewModel.hasData {
                    ScheduleView(events: homeViewModel.homeData?.events ?? [])
                        .padding(.top, 32)
                } else {

                    ScheduleView(events: [])
                        .padding(.top, 32)
                }
            }
            .padding(.bottom, 20)
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
        .background(Color.black.ignoresSafeArea())
    }
}

