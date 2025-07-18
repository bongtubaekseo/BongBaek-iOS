//
//  RelationshipSliderView.swift
//  BongBaek
//
//  Created by 임재현 on 7/4/25.
//

import SwiftUI

struct RelationshipSliderView: View {
    @EnvironmentObject var eventManager: EventCreationManager
    let range: ClosedRange<Double> = 1...5

    var body: some View {
        VStack(spacing: 30) {
            SliderSection(
                value: $eventManager.contactFrequency, 
                range: range,
                icon: "icon_message",
                title: "얼마나 자주 연락하나요?",
                knobImage: "Knob",
                leftLabel: "가끔",
                rightLabel: "매일"
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            SliderSection(
                value: $eventManager.meetFrequency,
                range: range,
                icon: "icon_handshake",
                title: "얼마나 자주 만나나요?",
                knobImage: "Knob 1",
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
    let knobImage: String
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
                fillTrack: .primaryNormal,
                thumbView: {
                    Image(knobImage)
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
