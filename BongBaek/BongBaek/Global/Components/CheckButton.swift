//
//  CheckButton.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI

struct CheckButton: View {
    let title: String
    let isRequired: Bool?
    @Binding var isChecked: Bool
    let hasDetailButton: Bool
    let manualToggle: Bool
    let isHighlighted: Bool
    let onTap: (() -> Void)?
    let onDetailTap: (() -> Void)?
    
    init(title: String,
         isRequired: Bool? = false,
         isChecked: Binding<Bool>,
         hasDetailButton: Bool = false,
         manualToggle: Bool = false,
         isHighlighted: Bool = false,
         onTap: (() -> Void)? = nil,
         onDetailTap: (() -> Void)? = nil) {
        self.title = title
        self.isRequired = isRequired
        self._isChecked = isChecked
        self.hasDetailButton = hasDetailButton
        self.manualToggle = manualToggle
        self.isHighlighted = isHighlighted
        self.onTap = onTap
        self.onDetailTap = onDetailTap
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isChecked ? Color.primaryNormal : Color.gray.opacity(0.5), lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isChecked ? Color.primaryNormal : Color.clear)
                    )
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray750)
                        .scaleEffect(isChecked ? 1.0 : 0.5)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isChecked)
                }
            }
            
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    if let isRequired = isRequired {
                        if isRequired {
                            Text("[필수]")
                                .bodyRegular16()
                                .foregroundColor(.gray300)
                        } else {
                            Text("[선택]")
                                .bodyRegular16()
                                .foregroundColor(.gray300)
                        }
                    }
                    
                    
                    if isHighlighted {
                        Text(title)
                            .titleSemiBold16()
                            .foregroundColor(.white)
                    } else {
                        Text(title)
                            .bodyRegular16()
                            .foregroundColor(.gray300)
                    }
                }
                
                Spacer()
                
                if hasDetailButton {
                    Button {
                        onDetailTap?()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray300)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {

            if !manualToggle {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isChecked.toggle()
                }
            } else {

            }
            onTap?()
        }
    }
}

