//
//  WelcomeTextView.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI

struct WelcomeTextView: View {
    var body: some View {
        
        VStack(alignment: .leading,spacing: 28) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("경조사비")
                        .foregroundStyle(.primaryStrong)
                        .headBold26()
                    
                    Text(" 고민 끝,")
                        .foregroundStyle(.white)
                        .headBold26()
                    
                    Spacer()
                }
                
                Text("봉투백서에 오신 것을")
                    .foregroundStyle(.white)
                    .headBold26()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("환영합니다!")
                    .foregroundStyle(.white)
                    .headBold26()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("3초 가입으로 바로 시작해보세요")
                .foregroundStyle(.white)
                .bodyMedium16()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

