//
//  ContentsCardView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//

import SwiftUI

struct ContentsCardView: View {
    let image : String
    let category: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 220, height: 160)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(category)
                    .font(.body1_medium_16)
                    .foregroundStyle(.txtDisplayPrimary)
                
                HStack {
                    Text(title)
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtStatusFocused)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Image("icon_left")
                        .frame(width: 20, height: 20)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.btnInteractiveSecondary)
        }
        .frame(width: 220, height: 256)
        .background(.btnInteractiveSecondary)
        .cornerRadius(6)
    }
}
