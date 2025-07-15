//
//  MainTabView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var previousTab: Tab = .home // 이전 탭 저장
    @State private var isRecommendFlowActive = false
    @StateObject private var stepManager = GlobalStepManager()
    @StateObject private var router = NavigationRouter()
    @StateObject private var eventManager = EventCreationManager()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 0) {
                Group {
                    if isRecommendFlowActive {
                        RecommendStartView(
                            onBackPressed: {
//                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isRecommendFlowActive = false
                                    selectedTab = previousTab // 이전 탭으로 복원
                                    router.popToRoot()
//                                }
                            }
                        )
                        .environmentObject(stepManager)
                        .environmentObject(router)
                    } else {
                        switch selectedTab {
                        case .home:
                            HomeView()
                                .environmentObject(stepManager)
                                .environmentObject(router)
                        case .recommend:
                            EmptyView()
                        case .record:
                            RecordView()
                                .environmentObject(router)
                        }
                    }
                }
                .animation(.none, value: isRecommendFlowActive)
                .animation(.none, value: selectedTab)
                // 조건부 탭바 표시
                if !isRecommendFlowActive {
                    CustomTabView(selectedTab: $selectedTab)
                        .background(Color.gray750)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 10,
                                topTrailingRadius: 10
                            )
                        )
//                        .ignoresSafeArea(.all)
//                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .background(Color.black.ignoresSafeArea())
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == .recommend {
                    previousTab = oldValue
                //    withAnimation(.easeInOut(duration: 0.3)) {
                        isRecommendFlowActive = true
             //       }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .selectTab)) { notification in
                print("📢 MainTabView에서 selectTab notification 받음")
                if let tab = notification.object as? Tab {
                    print("탭 변경: \(tab)")
                    isRecommendFlowActive = false
                    selectedTab = tab
                    router.popToRoot()
                }
            }
            .navigationDestination(for: RecommendRoute.self) { route in
                routeView(for: route)
            }
            
            
        }
    }
    
    @ViewBuilder
    private func routeView(for route: RecommendRoute) -> some View {
        switch route {
        case .recommendView:
            RecommendView()
                .environmentObject(stepManager)
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .eventInformationView:
            EventInformationView()
                .environmentObject(stepManager)
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .eventDateView:
            EventDateView()
                .environmentObject(stepManager)
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .eventLocationView:
            EventLocationView()
                .environmentObject(stepManager)
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .recommendLoadingView:
            RecommendLoadingView()
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .recommendLottie:
            RecommendLottie()
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .recommendCostView:
            RecommendCostView()
                .environmentObject(router)
                .environmentObject(eventManager)
                
        case .recommendSuccessView:
            RecommendSuccessView()
                .environmentObject(router)
                .environmentObject(eventManager)
        case .modifyEventView(let mode, let existingEvent):
            ModifyEventView(mode: mode, existingEvent: existingEvent)
                .environmentObject(router)
                .environmentObject(eventManager)
        case .fullScheduleView:
            FullScheduleView()
                .environmentObject(router)
        }
    }
}
//}

#Preview {
    MainTabView()
}
