//
//  TabbarView.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct TabbarView: View {
    @State var selectedTab: Tab = .home
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                Rectangle()
                    .fill(.yellow)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .recommend:
                Rectangle()
                    .fill(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .record:
                Rectangle()
                    .fill(.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            CustomTabView(selectedTab: $selectedTab)
                .background(Color.gray750)
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 10
                    )
                )
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
