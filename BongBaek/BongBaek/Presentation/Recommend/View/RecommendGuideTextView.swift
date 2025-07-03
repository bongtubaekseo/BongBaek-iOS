//
//  RecommendGuideTextView.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct RecommendGuideTextView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
 
            Text("경조사비,")
                .foregroundStyle(.white)
                .headBold26()
                    
            Text("얼마가 적당할까요?")
                .foregroundStyle(.white)
                .headBold26()
                .padding(.bottom, 16)
                
            Text("내 상황에 딱 맞는 경조사비,")
                .foregroundStyle(.gray300)
                .bodyMedium14()
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text("지금 바로 알아보세요!")
                .foregroundStyle(.gray300)
                .bodyMedium14()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
