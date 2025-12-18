//
//  RecommendGuideTextView.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct RecommendGuideTextView: View {
    let title1: String
    let title2: String
    let subtitle1: String
    let subtitle2: String
    let title1Style: TextStyle
    let title2Style: TextStyle
    let titleColor: Color
    let subtitleColor: Color
    let titleSpacing: CGFloat
    let titleSubtitleSpacing: CGFloat
    
    enum TextStyle {
        case headBold26
        case headBold24
        case titleSemiBold20
        case titleSemiBold18
        case titleSemiBold16
        
        @ViewBuilder
        func apply(to text: Text, color: Color) -> some View {
            switch self {
            case .headBold26:
                text.foregroundStyle(color).headBold26()
            case .headBold24:
                text.foregroundStyle(color).headBold24()
            case .titleSemiBold20:
                text.foregroundStyle(color).titleSemiBold20()
            case .titleSemiBold18:
                text.foregroundStyle(color).titleSemiBold18()
            case .titleSemiBold16:
                text.foregroundStyle(color).titleSemiBold16()
            }
        }
    }
    
    init(
        title1: String,
        title2: String,
        subtitle1: String,
        subtitle2: String,
        title1Style: TextStyle = .headBold26,
        title2Style: TextStyle = .headBold26,
        titleColor: Color = .txtDisplaySecondary,
        subtitleColor: Color = .txtDisplayTierary,
        titleSpacing: CGFloat = 4,
        titleSubtitleSpacing: CGFloat = 20
    ) {
        self.title1 = title1
        self.title2 = title2
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
        self.title1Style = title1Style
        self.title2Style = title2Style
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.titleSpacing = titleSpacing
        self.titleSubtitleSpacing = titleSubtitleSpacing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: titleSubtitleSpacing) {
            
            VStack(alignment: .leading, spacing: titleSpacing) { 
                title1Style.apply(to: Text(title1), color: titleColor)
                        
                title2Style.apply(to: Text(title2), color: titleColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(subtitle1)
                    .foregroundStyle(.txtDisplayTierary)
                    .bodyRegular14()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text(subtitle2)
                    .foregroundStyle(.txtDisplayTierary)
                    .bodyRegular14()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
