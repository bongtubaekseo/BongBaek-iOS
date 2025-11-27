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
            ScrollView(showsIndicators: false) {
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

                if homeViewModel.hasData {
                    NewScheduleView(event: homeViewModel.homeData?.events.first)
                        .padding(.top, 20)
                } else {
                    EmptyNewScheduleView()
                }
                
                if homeViewModel.hasData {
                    ScheduleView(events: homeViewModel.homeData?.events ?? [])
                        .padding(.top, 32)
                        .padding(.bottom, 10)
                } else {

                    ScheduleView(events: [])
                        .padding(.top, 32)
                        .padding(.bottom, 10)
                }
                
                Rectangle()
                    .fill(.borderDisplayTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)

        
                if homeViewModel.hasData {
                    RecommendsView(homeData: homeViewModel.homeData)
                            .environmentObject(stepManager)
                        .environmentObject(router)
                } else {
                    RecommendsView(homeData: nil)
                        .environmentObject(stepManager)
                        .environmentObject(router)
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
        .background(.bgDisplayPrimary)
    }
}

