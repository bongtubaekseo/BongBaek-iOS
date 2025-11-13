//
//  ContentsCardView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//

import SwiftUI

struct ContentsCardView: View {
    @EnvironmentObject var router : NavigationRouter
    let image : String
    let category: String
    let title: String
    
    var body: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.btnInteractiveSecondary)
                .frame(width: 220, height: 256)
            
            VStack(alignment: .leading, spacing: 0) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 160)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(category)
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtStatusFocused)
                    
                    Button(action : {
                        router.push(to : .contentDetailView)
                    }){
                        HStack {
                            Text(title)
                                .font(.body1_medium_16)
                                .foregroundStyle(.txtDisplayPrimary)
                                .lineLimit(2)
                            
                            Spacer()
                            
                            Image("icon_left")
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 220)
        }
        .frame(width: 220, height: 256)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
