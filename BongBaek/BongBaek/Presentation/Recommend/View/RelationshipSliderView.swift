//
//  RelationshipSliderView.swift
//  BongBaek
//
//  Created by 임재현 on 7/4/25.
//

import SwiftUI

struct RelationshipSliderView: View {
    @State private var contactValue: Double = 0
    @State private var intimacyValue: Double = 0
    let range: ClosedRange<Double> = 0...4

    var body: some View {
            VStack(spacing: 30) {
                SliderSection(
                    value: $contactValue,
                    range: range,
                    icon: "icon_message",
                    title: "얼마나 자주 연락하나요?",
                    leftLabel: "가끔",
                    rightLabel: "매일"
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                SliderSection(
                    value: $intimacyValue,
                    range: range,
                    icon: "icon_family",
                    title: "얼마나 자주 만나나요?",
                    leftLabel: "가끔",
                    rightLabel: "매일"
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        
        .background(.gray750)
        .padding(20)
        .frame(maxWidth: .infinity)
    }
}

struct SliderSection: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let icon: String
    let title: String
    let leftLabel: String
    let rightLabel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(icon)
                
                Text(title)
                    .bodyMedium16()
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 40)
            
            CustomSlider(
                value: $value,
                in: range,
                step: nil,
                barStyle: (6, 8),
                fillBackground: .gray.opacity(0.3),
                fillTrack: .blue,
                thumbView: {
                    Image("Knob")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.all, 12)
                        .frame(width: 88, height: 88)
                        .offset(y: 6)
                }
            )
            
            HStack {
                Text(leftLabel)
                    .captionRegular12()
                    .foregroundStyle(.gray400)
                
                Spacer()
                
                Text(rightLabel)
                    .captionRegular12()
                    .foregroundStyle(.gray400)
            }
            .padding(.top, 24)
        }
    }
}
