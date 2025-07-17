//
//  RecommendsView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct RecommendsView: View {
    @StateObject private var stepManager = GlobalStepManager()
    @EnvironmentObject var router: NavigationRouter
    let homeData: EventHomeData?
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("경조사비 추천")
                        .font(.caption_regular_12)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("내 상황에 어울리는 경조사비는?")
                        .font(.title_semibold_18)
                        .foregroundColor(.white)
                }
                .padding(.top,8)
                Spacer()
                
                Image(.iconCard)
                    .resizable()
                    .frame(width: 57, height: 54)
            }
            
            Button {
                router.push(to: .recommendStartView)
            } label: {
                Text("경조사비 추천 받기")
                    .font(.title_semibold_16)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.buttonBack)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.gray750)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

