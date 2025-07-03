//
//  StepProgressBar.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct StepProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    let progressColor: Color
    let backgroundColor: Color
    let height: CGFloat
    let showStepText: Bool
    let cornerRadius: CGFloat
    
    init(
        currentStep: Int,
        totalSteps: Int,
        progressColor: Color = .blue,
        backgroundColor: Color = .gray.opacity(0.2),
        height: CGFloat = 8,
        showStepText: Bool = true,
        cornerRadius: CGFloat = 4
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.height = height
        self.showStepText = showStepText
        self.cornerRadius = cornerRadius
    }
    
    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(currentStep) / Double(totalSteps)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if showStepText {
                HStack {
                    Text("\(currentStep)/\(totalSteps)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                        .frame(height: height)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(progressColor)
                        .frame(
                            width: geometry.size.width * progress,
                            height: height
                        )
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}
