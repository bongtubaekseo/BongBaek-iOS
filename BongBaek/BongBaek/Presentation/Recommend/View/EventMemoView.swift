//
//  EventMemoView.swift
//  BongBaek
//
//  Created by 임재현 on 7/17/25.
//

import SwiftUI

struct EventMemoView: View {
    @Binding var memo: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("메모")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if memo.isEmpty {
                        Text("메모를 입력해주세요")
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    
                    TextEditor(text: $memo)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 152)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.gray750)
                .cornerRadius(8)

            }
        }
    }
}
