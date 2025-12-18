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
                imageName: "tabBar_home",
                title: "홈"
            )
            
            TabBarItem(
                tab: .recommend,
                selectedTab: $selectedTab,
                imageName: "tabBar_money",
                title: "금액 추천"
            )
            
            TabBarItem(
                tab: .record,
                selectedTab: $selectedTab,
                imageName: "tabBar_write",
                title: "기록하기"
            )
            
            TabBarItem(
                tab: .contents,
                selectedTab: $selectedTab,
                imageName: "tabBar_article",
                title: "콘텐츠"
            )
            
            TabBarItem(
                tab: .setting,
                selectedTab: $selectedTab,
                imageName: "tabBar_setting",
                title: "설정"
            )
        }
        .padding(.bottom, 16)
        .frame(width: UIScreen.main.bounds.width, height: 92)
        .background(.gnbDisplayBase)
        .background(.primaryNormal)
    }
}

