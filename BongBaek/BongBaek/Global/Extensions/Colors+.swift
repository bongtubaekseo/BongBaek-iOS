//
//  Colors+.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//


import SwiftUI

extension Color {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // 또는 Color Asset의 색상들을 사용해서
    static let customBackgroundGradient = LinearGradient(
        gradient: Gradient(colors: [.gray750, Color(hex:"#171922")]),
        startPoint: .top,
        endPoint: .bottom
    )
}
