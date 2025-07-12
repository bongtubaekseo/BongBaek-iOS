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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    if isRecommendFlowActive {
                        RecommendStartView(
                            onBackPressed: {
//                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isRecommendFlowActive = false
                                    selectedTab = previousTab // 이전 탭으로 복원
//                                }
                            }
                        )
                        .environmentObject(stepManager)
                    } else {
                        switch selectedTab {
                        case .home:
                            HomeView()
                                .environmentObject(stepManager)
                        case .recommend:
                            EmptyView()
                        case .record:
                            RecordView()
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
        }
    }
}

#Preview {
    MainTabView()
}
