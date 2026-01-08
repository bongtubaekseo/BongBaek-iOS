//
//  TabBarItem.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct TabBarItem: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let selectedImageName: String
    let unselectedImageName: String
    let title: String
    
    private var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                Image(isSelected ? selectedImageName : unselectedImageName) 
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(isSelected ? .iconSelectedMenu : .iconDisabledPrimary)
                
                Text(title)
                    .bodyRegular14()
                    .foregroundStyle(isSelected ? .txtDisplayPrimary : .txtStatusDisabled)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
