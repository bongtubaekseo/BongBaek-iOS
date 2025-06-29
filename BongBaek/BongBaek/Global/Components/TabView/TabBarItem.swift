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
    let imageName: String
    let title: String
    
    private var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(isSelected ? .white : .gray400)
                
                Text(title)
                    .bodyRegular14()
                    .foregroundStyle(isSelected ? .white : .gray400)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
