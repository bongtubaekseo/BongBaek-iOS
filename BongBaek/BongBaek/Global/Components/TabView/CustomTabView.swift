//
//  CustomTabView.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                tab: .home,
                selectedTab: $selectedTab,
                imageName: "material-symbols-light_home-rounded",
                title: "홈"
            )
            
            TabBarItem(
                tab: .recommend,
                selectedTab: $selectedTab,
                imageName: "icon_coin_16",
                title: "금액 추천"
            )
            
            TabBarItem(
                tab: .record,
                selectedTab: $selectedTab,
                imageName: "mingcute_pen-fill",
                title: "기록하기"
            )
        }
        .frame(width: UIScreen.main.bounds.width, height: 91)
        .background(
            LinearGradient(
                colors: [.gray750.opacity(0.8), .gray900],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .background(.primaryNormal)
    }
}

