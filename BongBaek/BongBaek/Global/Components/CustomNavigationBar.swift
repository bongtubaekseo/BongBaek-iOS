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
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(.gray900)
        .overlay(
            Text(title)
                .titleSemiBold18()
                .foregroundColor(.white)
        )
    }
}

extension CustomNavigationBar {
    init(title: String) {
        self.title = title
        self.onBackTap = {}
    }
}
