//
//  FullScheduleEmptyView.swift
//  BongBaek
//
//  Created by 임재현 on 7/17/25.
//

import SwiftUI

struct FullScheduleEmptyView: View {
    @EnvironmentObject var router: NavigationRouter
    let message: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text("기록한 \(message)없어요!")
                .headBold24()
                .foregroundColor(.white)
            
            Text("지금 경조사를 기록하고")
                .bodyRegular14()
                .foregroundColor(.gray300)
                .padding(.top, 16)
            
            Text("상황에 어울리는 경조사비까지 추천받으세요")
                .bodyRegular14()
                .foregroundColor(.gray300)
            
            Image("Mask Group 5")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding(.top, 16)
            
            Button(action: {
                router.push(to: .createEventViewAfterEvent)
            }) {
                Text("지금 기록하기")
                    .titleSemiBold16()
                    .foregroundColor(.white)
                    .frame(width: 145)
                    .frame(height: 40)
            }
            
            
            .background(.primaryNormal)
            .cornerRadius(6)
            .padding(.horizontal, 40)
            .padding(.top, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}
