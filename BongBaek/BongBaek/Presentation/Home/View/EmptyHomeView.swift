//
//  EmptyHomeView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/12/25.
//
import SwiftUI

struct EmptyHomeView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var stepManager = GlobalStepManager()
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    HStack {
                        Text("봉투백서")
                            .headBold24()
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    EmptyScheduleView()
                        .frame(height: 276)
                        .padding(.top, 30)
                    RecommendsView()
                        .environmentObject(stepManager)
                        .padding(.top, 10)
                    HStack {
                        Text("봉백님의 일정")
                            .titleSemiBold20()
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .padding(.top,40)
                        Spacer()
                    }
                    EmptyCardView()
                        .environmentObject(stepManager)
                        .padding(.top, 20)
                }
//                CustomTabView(selectedTab: $selectedTab)
//                    .background(Color.gray750)
//                    .clipShape(
//                        .rect(
//                            topLeadingRadius: 10,
//                            topTrailingRadius: 10
//                        )
//                    )
            }
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    EmptyHomeView()
}

