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
        
        HStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("생년월일")
                    .font(.body1_medium_14)
                    .foregroundStyle(.gray200)
                Text("수입")
                    .font(.body1_medium_14)
                    .foregroundStyle(.gray200)
            }
            Spacer()
            
            VStack(alignment: .trailing, spacing: 20) {
                Text("2000년 01월 05일")
                    .font(.body1_medium_14)
                    .foregroundStyle(.gray100)
                Text("없음")
                    .font(.body1_medium_14)
                    .foregroundStyle(.gray100)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.gray750)
        .cornerRadius(20)
        
        VStack(alignment: .leading, spacing: 20){
            Text("서비스")
                .font(.title_semibold_18)
                .foregroundStyle(.black)
                .padding(.leading, 20)
                .padding(.top, 14)
                .padding(.bottom, 4)
        }
    }
}
