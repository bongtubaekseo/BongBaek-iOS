//
//  DetailRecommendButton.swift
//  BongBaek
//
//  Created by 임재현 on 7/4/25.
//

import SwiftUI

struct DetailRecommendButton: View {
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("선택")
                            .captionRegular12()
                            .foregroundColor(.txtStatusFocused)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isSelected ? .bgDisplayCard : .btnInteractiveDisabled)
                            .cornerRadius(4)
                        
                        Text("더 정확한 추천을 받고 싶다면?")
                            .titleSemiBold16()
                            .foregroundStyle(.txtDisplaySecondary)
                        
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    
                    VStack(alignment: .leading,spacing:4) {
                        Text("관계의 친밀도를 알려주시면")
                            .bodyRegular14()
                            .foregroundColor(isSelected ? .txtDisplaySecondary : .txtDisplayTierary)
                        
                        Text("더 정확한 정보를 받을 수 있어요")
                            .bodyRegular14()
                            .foregroundColor(isSelected ? .txtDisplaySecondary : .txtDisplayTierary)
                    }
                    

                }
                
                Spacer()
                
                Image(isSelected ? "checkbox 1" : "checkbox")
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .btnInteractiveTierary : .borderFieldDefault)
                    .frame(width:30,height: 30)
            }
            .padding()
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 83)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .bgStatusFocused : .bgDisplayCard)
                    .stroke(.borderFieldDefault, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

