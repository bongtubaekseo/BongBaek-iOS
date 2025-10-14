//
//  FocusButton.swift
//  BongBaek
//
//  Created by hyunwoo on 10/14/25.
//
import SwiftUI

struct FocusButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title_semibold_16)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.buttonBack)
                .cornerRadius(10)
        }
    }
}
