//
//  HomeView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//
import SwiftUI

//struct HomeView: View {
//    @State private var selectedTab: Tab = .home
//    @StateObject private var stepManager = GlobalStepManager()
//    @EnvironmentObject var router: NavigationRouter
//    @StateObject private var homeViewModel = HomeViewModel()
//    @StateObject private var loginVM = LoginViewModel()
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            ScrollView(showsIndicators: false) {
//                HStack {
//                    Image(.logoSymbol)
//                        .frame(width: 20, height: 20)
//                    
//                    Text("봉투백서")
//                        .brandBold18()
//                        .foregroundColor(.txtDisplayPrimary)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.top, 30)
//                .padding(.leading, 20)
//
//                if homeViewModel.hasData,
//                   let firstEvent = homeViewModel.homeData?.events.first {
//                    NewScheduleView(event: firstEvent)
//                        .padding(.top, 20)
//                } else if homeViewModel.isLoading {
//                    VStack {
//                        ProgressView("일정을 불러오는 중…")
//                            .foregroundColor(.white)
//                    }
//                    .padding(.top, 20)
//                    .padding(.horizontal, 20)
//                } else {
//                    EmptyNewScheduleView()
//                        .padding(.top, 20)
//                }
//                
//                VStack(spacing: 0) {
//                    ScheduleView(events: homeViewModel.homeData?.events ?? [])
//                        .padding(.top, 32)
//                        .padding(.bottom,20)
//                    
//                    Rectangle()
//                        .fill(.bgDisplayPrimary)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 10)
//                  
//                    Rectangle()
//                        .fill(.borderDisplayTitle)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 10)
//                    
//                    RecommendsView()
//                    .background(.yellow)
//                    .environmentObject(stepManager)
//                    .environmentObject(router)
//
//                    HomeContentsView(homeContents: homeViewModel.homeContents)
//                    
//                    
//                    }
//                .background(.red)
//                
//            }
//        }
//        .onAppear {
//            print("HomeView 나타남 - 데이터 로드 시작")
//            homeViewModel.loadData()
//            
//            Task {
//                await homeViewModel.loadHomeContents()
//            }
//        }
//        .refreshable {
//            print("HomeView 새로고침")
//            homeViewModel.refreshData()
//        }
//        .navigationBarHidden(true)
//        .toolbar(.hidden, for: .navigationBar)
//        .navigationBarBackButtonHidden(true)
//        .background(.bgDisplayPrimary)
//    }
//}


struct HomeView: View {
    
    @State private var selectedTab: Tab = .home
    @StateObject private var stepManager = GlobalStepManager()
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
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
                
                
                if let firstEvent = homeViewModel.homeData?.events.first {
                    NewScheduleView(event: firstEvent)
                        .padding(.top, 32)
                } else if homeViewModel.isLoading {
                    ProgressView("일정을 불러오는 중…")
                        .foregroundColor(.white)
                        .padding(.top, 32)
                } else {
                    EmptyNewScheduleView()
                        .padding(.top, 32)
                }
                
                ScheduleView(events: homeViewModel.homeData?.events ?? [])
                    .padding(.top, 40)
                    .padding(.bottom,20)
                
                Rectangle()
                    .fill(.bgDisplayPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                
                Rectangle()
                    .fill(.borderDisplayTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                
                RecommendsView()
                    .environmentObject(stepManager)
                    .environmentObject(router)
                
                HomeContentsView(homeContents: homeViewModel.homeContents)
                
                Color.clear.frame(height: 122)
                
            }
        }
        .onAppear {
            print("HomeView 나타남 - 데이터 로드 시작")
            homeViewModel.loadData()
        
            Task {
                await homeViewModel.loadHomeContents()
            }
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
