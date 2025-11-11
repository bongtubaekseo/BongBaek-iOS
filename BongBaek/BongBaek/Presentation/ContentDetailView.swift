//
//  ContentDetailView.swift
//  BongBaek
//
//  Created by 임재현 on 11/8/25.
//

import SwiftUI

struct ContentDetailView: View {
    @EnvironmentObject var router: NavigationRouter
    
    let cardImages = ["image1", "image2"]
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "") {
                router.pop()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("경조사 유형")
                            .captionRegular12()
                            .foregroundStyle(.txtStatusFocused)
                        
                        Text("이제는 알아야 할 결혼식 식사 예절")
                            .titleSemiBold20()
                            .foregroundStyle(.txtDisplayPrimary)
                            .padding(.top, 2)
                            
                        Text("2025. 01. 01")
                            .bodyRegular14()
                            .foregroundStyle(.txtDisplayTierary)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        ForEach(cardImages.indices, id: \.self) { index in
                            Image(cardImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                        }
                    }
                    .padding(.top, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.bgDisplayPrimary)
    }
}

