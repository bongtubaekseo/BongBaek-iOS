//
//  WelcomeTextView.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI

struct WelcomeTextView: View {
    var body: some View {
        
        VStack(alignment: .leading,spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("경조사비")
                        .foregroundStyle(Color(hex: "#CDC9FF"))
                        .headBold26()
                    
                    Text(" 고민 끝,")
                        .foregroundStyle(Color(hex: "#CDC9FF"))
                        .headBold26()
                    
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Text("봉투백서")
                        .foregroundStyle(.white)
                        .headBold26()
                    
                    Text("에 오신 것을")
                        .foregroundStyle(Color(hex: "#CDC9FF"))
                        .headBold26()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("환영합니다!")
                    .foregroundStyle(Color(hex: "#CDC9FF"))
                    .headBold26()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("3초 가입으로 바로 시작해보세요")
                .foregroundStyle(.gray100)
                .bodyMedium16()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

