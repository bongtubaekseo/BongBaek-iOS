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
                imageName: "Property 1=selected",
                title: "기록하기"
            )
            
            TabBarItem(
                tab: .contents,
                selectedTab: $selectedTab,
                imageName: "icon=icon_contents, status=off",
                title: "콘텐츠"
            )
            
            TabBarItem(
                tab: .setting,
                selectedTab: $selectedTab,
                imageName: "icon=icon_setting, status=on",
                title: "설정"
            )
        }
        .padding(.bottom, 16)
        .frame(width: UIScreen.main.bounds.width, height: 92)
        .background(.gnbDisplayBase)
        .background(.primaryNormal)
    }
}

