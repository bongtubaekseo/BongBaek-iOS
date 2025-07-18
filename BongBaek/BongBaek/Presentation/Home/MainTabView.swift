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
                        RecommendStartView()
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
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .background(Color.black.ignoresSafeArea())
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == .recommend {
                    selectedTab = oldValue
                    router.push(to: .recommendStartView)  
                }
            }
            .onChange(of: router.path) { oldPath, newPath in
                        // 추천 플로우 중에 mainTab으로 돌아온 경우
                        if !oldPath.isEmpty && newPath.isEmpty {
                            print("🔄 mainTab으로 복귀 - EventCreationManager 리셋")
                            eventManager.resetAllData()
                        }
                    }
//            .onReceive(NotificationCenter.default.publisher(for: .selectTab)) { notification in
//                print("📢 MainTabView에서 selectTab notification 받음")
//                if let tab = notification.object as? Tab {
//                    print("탭 변경: \(tab)")
//                    isRecommendFlowActive = false
//                    selectedTab = tab
//                    router.popToRoot()
//                }
//            }
            
            .onReceive(NotificationCenter.default.publisher(for: .selectTab)) { notification in
               print("📢 MainTabView에서 selectTab notification 받음")
               if let tab = notification.object as? Tab {
                   print("탭 변경: \(tab)")
                   
                   // 추천 플로우 중에 탭 전환 시 데이터 리셋
                   if !router.path.isEmpty {
                       print("🔄 탭 전환으로 인한 EventCreationManager 리셋")
                       eventManager.resetAllData()
                   }
                   
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
        case .modifyEventView(let mode, let eventDetailData):
            ModifyEventView(mode: mode, eventDetailData: eventDetailData)
                .environmentObject(router)
                .environmentObject(eventManager)
        case .fullScheduleView:
            FullScheduleView()
                .environmentObject(router)
        case .allRecordView(let eventId):
            AllRecordsView(eventId: eventId)
                .environmentObject(router)
            
        case .allRecordView2(let eventId):
            AllRecordsView2(eventId: eventId)
                .environmentObject(router)
            
        case .recommendStartView:
            RecommendStartView()
            .environmentObject(router)
            .environmentObject(eventManager)
        case .emptyScheduleView:
            EmptyScheduleView()
                .environmentObject(router)
            
        case .emptyCardView:
            EmptyCardView()
                .environmentObject(router)
        case .createEventView:
            CreateEventView()
                .environmentObject(router)
        case .createEventViewAfterEvent:
            CreateEventViewAfterEvent()
                .environmentObject(router)
            
//        case .largeMapView:
//            LargeMapView()
//                .environmentObject(router)
//                .environmentObject(eventManager)
        case .modifyEventView2(let mode, let eventDetailData):
            ModifyEventView2(mode: mode, eventDetailData: eventDetailData)
                .environmentObject(router)
                .environmentObject(eventManager)
        }
    }
}
//}

#Preview {
    MainTabView()
}
