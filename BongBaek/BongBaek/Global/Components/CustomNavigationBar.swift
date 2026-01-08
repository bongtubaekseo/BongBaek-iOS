//
//  CustomNavigationBar.swift
//  BongBaek
//
//  Created by 임재현 on 7/2/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    let onBackTap: () -> Void
    
    init(title: String, onBackTap: @escaping () -> Void) {
        self.title = title
        self.onBackTap = onBackTap
    }
    
    var body: some View {
        HStack {
            Button(action: {
                onBackTap()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.iconInteractiveDefault)
                    .frame(width: 24, height: 24, alignment: .leading)
            }
            .contentShape(Rectangle())
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(.bgDisplayPrimary)
        .overlay(
            Text(title)
                .titleSemiBold18()
                .foregroundColor(.txtDisplayPrimary)
        )
    }
}

extension CustomNavigationBar {
    init(title: String) {
        self.title = title
        self.onBackTap = {}
    }
}
