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

            HStack(spacing: 4) {
                Text(model.type)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.primaryNormal)
                    .cornerRadius(4)
                Text(model.relation)
                    .captionRegular12()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.primaryNormal)
                    .cornerRadius(4)
            }

            Text(model.date)
                .captionRegular12()
                .foregroundColor(.gray400)
        }
        .padding()
        .background(.gray750)
        .cornerRadius(10)
    }
}
