//
//  Font+.swift
//  BongBaek
//
//  Created by 임재현 on 7/5/25.
//

import SwiftUI

extension Font {
    static let head_bold_26 = Font.custom("Pretendard-Bold", size: 26)
    static let head_bold_24 = Font.custom("Pretendard-Bold", size: 24)
    
    static let title_semibold_20 = Font.custom("Pretendard-SemiBold", size: 20)
    static let title_semibold_18 = Font.custom("Pretendard-SemiBold", size: 18)
    static let title_semibold_16 = Font.custom("Pretendard-SemiBold", size: 16)
    
    static let body1_medium_16 = Font.custom("Pretendard-Medium", size: 16)
    static let body1_medium_14 = Font.custom("Pretendard-Medium", size: 14)
    
    static let body2_regular_16 = Font.custom("Pretendard-Regular", size: 16)
    static let body2_regular_14 = Font.custom("Pretendard-Regular", size: 14)
    
    static let caption_regular_12 = Font.custom("Pretendard-Regular", size: 12)
}


extension Text {
    func headBold26() -> some View {
        self.font(.head_bold_26)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 26, percent: -2))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 26,
                weight: .bold,
                targetLineHeightPercent: 130
            )
        )
    }
    
    func headBold24() -> some View {
        self.font(.head_bold_24)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 24, percent: -3))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 24,
                weight: .bold,
                targetLineHeightPercent: 130
            )
        )
    }
    
    func titleSemiBold20() -> some View {
        self.font(.title_semibold_20)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 20, percent: -3))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 20,
                weight: .semibold,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func titleSemiBold18() -> some View {
        self.font(.title_semibold_18)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 18, percent: -2))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 18,
                weight: .semibold,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func titleSemiBold16() -> some View {
        self.font(.title_semibold_16)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 16, percent: -2))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 16,
                weight: .semibold,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func bodyMedium16() -> some View {
        self.font(.body1_medium_16)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 16, percent: -1))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 16,
                weight: .medium,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func bodyMedium14() -> some View {
        self.font(.body1_medium_14)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 14, percent: -1))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 14,
                weight: .medium,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func bodyRegular16() -> some View {
        self.font(.body2_regular_16)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 16, percent: -1))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 16,
                weight: .regular,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func bodyRegular14() -> some View {
        self.font(.body2_regular_14)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 14, percent: -1))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 14,
                weight: .regular,
                targetLineHeightPercent: 150
            )
        )
    }
    
    func captionRegular12() -> some View {
        self.font(.caption_regular_12)
            .kerning(TypographyHelper.customLetterSpacing(fontSize: 12, percent: -1))
            .lineSpacing(TypographyHelper.customLineHeight(
                fontSize: 12,
                weight: .regular,
                targetLineHeightPercent: 130
            )
        )
    }
}

struct TypographyHelper {
    /// Letter Spacing 계산 (퍼센트 기준)
    static func customLetterSpacing(fontSize: CGFloat, percent: CGFloat) -> CGFloat {
        
        return fontSize * (percent / 100)
    }
    
    /// Line Height 계산 (퍼센트 기준)
    static func customLineHeight(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        targetLineHeightPercent:CGFloat
    ) -> CGFloat {
        
        let UIFont = UIFont.systemFont(ofSize: fontSize,weight: weight)
        let defaultLineHeight = UIFont.lineHeight
        let targetLineHeight = fontSize * (targetLineHeightPercent / 100)
        let additionalSpacing = targetLineHeight - defaultLineHeight
        return max(0,additionalSpacing)
    }
}
