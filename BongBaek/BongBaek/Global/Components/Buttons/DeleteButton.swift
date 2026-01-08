//
//  DeleteButton.swift
//  BongBaek
//
//  Created by hyunwoo on 10/14/25.
//
import SwiftUI

struct DeleteButton: View {
    let title : String
    let action : () -> Void
    
    var body : some View{
        Button{
            action()
        } label : {
            Text(title)
                .font(.title_semibold_18)
                .foregroundStyle(.borderStatusError)
                .frame(maxWidth: .infinity)
                .padding()
                .background()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.borderStatusError, lineWidth : 1)
                )
        }
    }
}
