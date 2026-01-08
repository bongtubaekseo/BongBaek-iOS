//
//  Untitled.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//

import SwiftUI

struct SmallButton_cts: View {
    let title : String
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title_semibold_16)
                .foregroundStyle(.txtInteractiveInverse)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bgStatusFocused)
                .cornerRadius(6)
        }
    }
}
