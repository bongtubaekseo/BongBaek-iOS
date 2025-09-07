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

extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
