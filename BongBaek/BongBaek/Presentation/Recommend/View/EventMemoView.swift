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
    let isDisabled: Bool
    private let maxLength = 50
    
    init(memo: Binding<String>, isDisabled: Bool = false) {
        self._memo = memo
        self.isDisabled = isDisabled
    }
    
    private var borderColor: Color {
        if isDisabled {
            return .clear
        } else if memo.count >= maxLength {
            return .clear
        } else if isFocused {
            return .primaryNormal
        } else {
            return .clear
        }
    }
    
    private var borderLineWidth: CGFloat {
        if isDisabled {
            return 0
        } else if memo.count >= maxLength || isFocused {
            return 1
        } else {
            return 0
        }
    }
    
    private var backgroundColor: Color {
        if isDisabled {
            return .gray800
        } else if memo.isEmpty {
            return .gray800
        } else {
            return .gray750
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("메모")
                    .titleSemiBold18()
                    .foregroundStyle(isDisabled ? .gray500 : .white)
                
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
                        .foregroundColor(isDisabled ? .gray400 : .white)
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 152)
                        .disabled(isDisabled)
                        .onChange(of: memo) { _, newValue in
                            // 엔터키 감지하여 키보드 내리기
                            if newValue.hasSuffix("\n") {
                                // 마지막 줄바꿈 문자 제거
                                memo = String(newValue.dropLast())
                                // 키보드 내리기
                                isFocused = false
                                return
                            }
                            
                            // 50자 제한
                            if newValue.count > maxLength {
                                memo = String(newValue.prefix(maxLength))
                            }
                        }
            
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(memo.count)/\(maxLength)")
                                .font(.system(size: 12))
                                .foregroundColor(memo.count >= maxLength ? .red : .gray400)
                                .padding(.trailing, 8)
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderLineWidth)
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: memo.count >= maxLength)
                .animation(.easeInOut(duration: 0.2), value: memo.isEmpty)
            }
        }
    }
}
