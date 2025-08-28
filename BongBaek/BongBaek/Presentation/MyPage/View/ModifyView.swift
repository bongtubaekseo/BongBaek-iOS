//
//  ModifyView.swift
//  BongBaek
//
//  Created by hyunwoo on 8/28/25.
//
import SwiftUI

struct ModifyView: View {
    
    var body: some View {
        VStack(spacing : 16) {
            Image(.myPageLogo)
                .frame(width: 110, height: 110)
                .padding(.top, 9)
                .padding(.bottom, 9)
            
            Text("봉투백서의겸손한야수")
                .font(.head_bold_24)
                .foregroundStyle(.gray100)
            
            Button(action: {}){
                Text("내 정보 수정")
                    .font(.caption_regular_12)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.primaryNormal)
                    .cornerRadius(20)
            }
        }
        .background(Color.black)
    }
}
