//
//  FocusButton.swift
//  BongBaek
//
//  Created by hyunwoo on 10/14/25.
//
import SwiftUI

struct FocusButton: View {
    let title: String
    let isFocuesed : Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title_semibold_16)
                .foregroundColor(isFocuesed ? .txtInteractiveInverse : .txtStatusDisabled)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFocuesed ? .bgStatusFocused: .btnInteractiveDisabled)
                .cornerRadius(10)
        }
        .disabled(!isFocuesed)
    }
}
