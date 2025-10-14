//
//  SmallButton.swift
//  BongBaek
//
//  Created by hyunwoo on 10/14/25.
//
import SwiftUI

struct SmallButton: View {
    let title : String
    let action : () -> Void
    let isselected : Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.body1_medium_16)
                .foregroundStyle(isselected ? .white : .gray500)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isselected ? Color(.primaryNormal) : .gray800)
                        )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.lineNormal, lineWidth:
                                    isselected ? 0 : 1)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
