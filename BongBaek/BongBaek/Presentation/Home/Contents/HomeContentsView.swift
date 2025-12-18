//
//  ContentsView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//
import SwiftUI

struct HomeContentsView: View {
    @EnvironmentObject var router: NavigationRouter
    let homeContents: ContentsHomeResponseData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("경조사 콘텐츠")
                        .font(.title_semibold_20)
                        .foregroundStyle(.txtDisplayPrimary)
                    Text("경조사 가기 전 꼭 확인해야 할 정보")
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtDisplayTierary)
                }
                .padding(.horizontal, 20)
                Spacer()
                
                Button(action: {
                    NotificationCenter.default.post(
                        name: .selectTab,
                        object: Tab.contents
                    )
                }) {
                    HStack {
                        Text("더보기")
                            .bodyRegular14()
                            .foregroundColor(.txtDisplaySecondary)
                            //.padding(.trailing, 4)
                        
                        Image("icon_arrow")
                            .foregroundColor(.txtDisplayTierary)
                            .frame(width: 14, height: 14)
                            .padding(.trailing, 4)
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            if let contents = homeContents?.contents, !contents.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(contents, id: \.contentId) { content in
                            ContentsCardView(
                                contentId: content.contentId,
                                image: content.thumbnailUrl,
                                category: content.contentCategory,
                                title: content.contentTitle
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                // 로딩 중이거나 데이터가 없을 때
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // 스켈레톤 UI 또는 빈 상태
                        Text("콘텐츠를 불러오는 중...")
                            .foregroundColor(.txtDisplaySecondary)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical, 20)
    }
}
