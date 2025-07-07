//
//  FullScheduleCellView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/6/25.
//

import SwiftUI

struct FullScheduleCellView: View {
    let model: ScheduleModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("nickname")
                .captionRegular12()
                .foregroundColor(.primaryNormal)

            HStack {
                Text(model.name)
                    .titleSemiBold18()
                    .foregroundColor(.white)
                Spacer()
                Text(model.money)
                    .titleSemiBold18()
                    .foregroundColor(.white)
            }

            HStack {
                HStack(spacing: 8) {
                    Text(model.type)
                        .captionRegular12()
                        .foregroundColor(.primaryNormal)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.primaryNormal.opacity(0.1))
                        .cornerRadius(4)
                    Text(model.relation)
                        .captionRegular12()
                        .foregroundColor(.primaryNormal)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.primaryNormal.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Text(model.date)
                    .captionRegular12()
                    .foregroundColor(.gray400)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.gray750)
        .cornerRadius(10)
    }
}
