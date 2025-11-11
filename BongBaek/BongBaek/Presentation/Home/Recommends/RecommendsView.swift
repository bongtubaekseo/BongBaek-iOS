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
                    Text("금액 추천")
                        .font(.caption_regular_12)
                        .foregroundColor(.txtStatusFocused)
                    
                    Text("내 상황에 어울리는 경조사비는?")
                        .font(.title_semibold_18)
                        .foregroundColor(.txtDisplayPrimary)
                }
                .padding(.top,8)
            }
            
            Button {
                router.push(to: .recommendStartView)
            } label: {
                Text("경조사비 추천 받기")
                    .font(.body1_medium_16)
                    .foregroundStyle(.txtInteractiveInverse)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.btnInteractiveAccent)
                    .cornerRadius(8)
            }
            
        }
        .padding()
        .background(.bgDisplaySecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderDisplayDivider, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

//#Preview {
//    RecommendsView(homeData: nil)
//        .preferredColorScheme(.dark)
//}


