//
//  ContentsView.swift
//  BongBaek
//
//  Created by hyunwoo on 11/11/25.
//
import SwiftUI

struct HomeContentsView: View{
    @EnvironmentObject var router: NavigationRouter
    
    var body : some View{
        VStack(alignment: .leading, spacing: 12){
            HStack{
                VStack(alignment: .leading, spacing: 2){
                    Text("경조사 콘텐츠")
                        .font(.title_semibold_20)
                        .foregroundStyle(.txtDisplayPrimary)
                    Text("경조사 가기 전 꼭 확인해야 할 정보")
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtDisplayTierary)
                }
                Spacer()
                
                Button(action : {
                    router.push(to: .contentsView)
                }){
                    HStack(spacing: 4) {
                        Text("더보기")
                            .bodyRegular14()
                            .foregroundColor(.txtDisplaySecondary)
                        
                        Image("icon_left")
                            .foregroundColor(.gray400)
                            .frame(width: 14, height: 14)
                    }
                }
            }
        }
    }
}
