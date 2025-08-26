//
//  EventMapView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct EventMapView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack {
                    Image("icon_location_16")
                    Text("행사장")
                        .bodyMedium14()
                        .foregroundStyle(.gray300)
                }
                
                Spacer()
                
                Button {
                    print("수정하기")
                } label: {
                    Text("수정하기")
                        .bodyRegular14()
                        .foregroundStyle(.gray300)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("강남 웨딩홀")
                        .bodyMedium16()
                        .foregroundStyle(.white)
                    
                    Text("강남구 테헤란로 123-4 567호")
                        .bodyMedium16()
                        .foregroundStyle(.gray300)
                }
            }
        }
        .background(.gray800)
    }
}
