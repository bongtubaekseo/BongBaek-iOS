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
            VStack(spacing: 4) {
                Image(image)
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .white : .primaryNormal)
                    .frame(width: 48, height: 40) 
                    .scaledToFit()
                
                Text(text)
                    .bodyMedium14()
                    .foregroundColor(isSelected ? .white : .gray200)
            }
            .frame(maxWidth: .infinity, minHeight: 83)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .primaryNormal : .gray750)
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
