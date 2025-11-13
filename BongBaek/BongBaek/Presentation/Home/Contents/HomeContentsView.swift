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
        VStack(alignment: .leading, spacing: 16){
            HStack{
                VStack(alignment: .leading, spacing : 2){
                    Text("경조사 콘텐츠")
                        .font(.title_semibold_20)
                        .foregroundStyle(.txtDisplayPrimary)
                    Text("경조사 가기 전 꼭 확인해야 할 정보")
                        .font(.caption_regular_12)
                        .foregroundStyle(.txtDisplayTierary)
                }
                .padding(.horizontal, 20)
                Spacer()
                
                Button(action : {
                    router.push(to: .contentsView)
                }){
                    HStack{
                        Text("더보기")
                            .bodyRegular14()
                            .foregroundColor(.txtDisplaySecondary)
                        
                        Image("icon_left")
                            .foregroundColor(.gray400)
                            .frame(width: 14, height: 14)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 16)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 8){
                    ContentsCardView(
                        image: "ContentsEx1",
                        category: "결혼식",
                        title: "이제는 알아야 하는 결혼식 식사 예절"
                    )
                    ContentsCardView(
                        image: "ContentsEx2",
                        category: "장례식",
                        title: "이제는 알아야 하는 장례식 예절"
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview{
    HomeContentsView()
}
