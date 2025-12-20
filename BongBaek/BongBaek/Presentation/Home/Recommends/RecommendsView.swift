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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("금액 추천")
                        .captionRegular12()
                        .foregroundColor(.txtStatusFocused)
                    
                    Text("내 상황에 어울리는 경조사비는?")
                        .titleSemiBold18()
                        .foregroundColor(.txtDisplayPrimary)
                }
                .padding(.leading,2)
            }
            

            Button {
                router.push(to: .recommendStartView)
            } label: {
                Text("경조사비 추천 받기")
                    .bodyMedium16()
                    .foregroundStyle(.txtInteractiveInverse)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
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
        .padding(.horizontal,20)
        .padding(.vertical,30)
    }
}



