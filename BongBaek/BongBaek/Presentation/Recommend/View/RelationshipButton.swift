//
//  RelationshipButton.swift
//  BongBaek
//
//  Created by 임재현 on 7/4/25.
//

import SwiftUI

struct RelationshipButton: View {
    var image: String
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(image)
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .white : .primaryNormal)
                
                Text(text)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray200)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 83)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .primaryNormal : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.lineNormal, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}


