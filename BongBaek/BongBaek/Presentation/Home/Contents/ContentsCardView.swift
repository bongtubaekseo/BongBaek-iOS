//
//  ContentsCardView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//

import SwiftUI

struct ContentsCardView: View {
    @EnvironmentObject var router : NavigationRouter
    let contentId: String
    let image : String
    let category: String
    let title: String
    
    var body: some View {
        Button(action : {
            router.push(to : .contentDetailView(contentId: contentId))
        }){
            ZStack(alignment: .topLeading){
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.btnInteractiveSecondary)
                    .frame(width: 220, height: 256)
                
                VStack(alignment: .leading, spacing: 0) {
                    AsyncImage(url: URL(string: image)) { phase in
                        switch phase {
                        case .empty:
                            // 로딩 중
                            Rectangle()
                                .fill(Color.gray200)
                                .frame(width: 220, height: 160)
                                .overlay {
                                    ProgressView()
                                }
                        case .success(let image):
                            // 이미지 로드 성공
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 220, height: 160)
                                .clipped()
                        case .failure:
                            // 로드 실패
                            Rectangle()
                                .fill(Color.gray200)
                                .frame(width: 220, height: 160)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray400)
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category)
                            .captionRegular12()
                            .foregroundStyle(.txtStatusFocused)
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text(title)
                                .bodyMedium16()
                                .foregroundStyle(.txtDisplayPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image("icon_arrow")
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.iconInteractiveDefault)
                                .fixedSize()
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.btnInteractiveSecondary)
            .frame(width: 220, height: 256)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}
