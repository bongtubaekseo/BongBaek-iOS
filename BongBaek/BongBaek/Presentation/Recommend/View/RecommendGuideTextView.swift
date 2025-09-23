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
    let spacing: CGFloat
    
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
        titleColor: Color = .gray100,
        subtitleColor: Color = .gray400,
        spacing: CGFloat = 12
    ) {
        self.title1 = title1
        self.title2 = title2
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
        self.title1Style = title1Style
        self.title2Style = title2Style
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.spacing = spacing
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 4) {
                title1Style.apply(to: Text(title1), color: titleColor)
                        
                title2Style.apply(to: Text(title2), color: titleColor)
            }
            .padding(.bottom, spacing)
            
            VStack(alignment: .leading) {
                Text(subtitle1)
                    .foregroundStyle(subtitleColor)
                    .bodyMedium14()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text(subtitle2)
                    .foregroundStyle(subtitleColor)
                    .bodyMedium14()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
