//
//  SecondaryButton.swift
//  BongBaek
//
//  Created by hyunwoo on 10/21/25.
//
import SwiftUI

struct SecondaryButton : View {
    let title : String
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title_semibold_18)
                .foregroundStyle(.gray200)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray700)
                .cornerRadius(10)
        }
    }
}

