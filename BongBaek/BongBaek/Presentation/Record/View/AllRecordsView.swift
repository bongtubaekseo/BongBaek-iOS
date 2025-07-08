//
//  AllRecordsView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct AllRecordsView: View {
    @State private var isDetailExpanded = false
    @State private var memoText = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView {
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)

                    }
                    .contentShape(Rectangle())
                    
                    Text("경조사 전체기록")
                        .titleSemiBold18()
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: {
                    }) {
                        Image("icon_edit")
                            .foregroundColor(.white)
                    }
                    .contentShape(Rectangle())
                    .padding(.trailing, 20)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                
                VStack(spacing: 12) {
                    VStack {
                        Text("김승우의 결혼식")
                            .titleSemiBold16()
                            .foregroundStyle(.white)
                            
                        Text("2024.08.10 (토)")
                            .bodyRegular14()
                            .foregroundStyle(.gray300)
      
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(.gray750)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    HStack {
                        Text("경조사비")
                            .titleSemiBold16()
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("50,000원")
                            .titleSemiBold18()
                            .foregroundStyle(.white)

                    }
                    .padding(20)
                    .background(.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top,8)
                    
                    // 상세정보 토글 버튼
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isDetailExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("상세정보")
                                .titleSemiBold18()
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Image(systemName: isDetailExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                                .animation(.easeInOut(duration: 0.3), value: isDetailExpanded)
                        }

                        .background(Color.background)
                    }
                    .padding(.horizontal, 20)
                    .buttonStyle(PlainButtonStyle())
                    
                    if isDetailExpanded {
                        VStack(alignment: .leading, spacing: 24) {
                            DetailRow(image: "icon_person_16", title: "이름", value: "김봉백")
                            DetailRow(image: "icon_nickname_16", title: "별명", value: "봉봉")
                            DetailRow(image: "icon_event_16", title: "관계", value: "가족/친척", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                            
                            DetailRow(image: "icon_event_16", title: "경조사", value: "결혼식", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                            DetailRow(image: "icon_event_16", title: "경조사비", value: "50,000원")
                            DetailRow(image: "icon_event_16", title: "참석여부", value: "참석", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                            DetailRow(image: "icon_event_16", title: "날짜", value: "Jun 10, 2024", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                        }
                        .padding(20)
                        .background(.gray750)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
                            removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
                        ))
                    }
                
                
                    HStack {
                        Text("메모")
                            .titleSemiBold18()
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top,12)
                    
                    VStack(alignment: .leading) {
                        TextEditor(text: $memoText)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .frame(minHeight: 100, maxHeight: 200)
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    
                    Button {
                    } label: {
                        Text("기록 삭제하기")
                            .titleSemiBold18()
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.red, lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                }
                .padding(.vertical, 16)
            }
        }
        .background(Color.background)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct DetailRow: View {
    let image: String
    let title: String
    let value: String
    let valueTextColor: Color?
    let valueBackgroundColor: Color?
    
    init(image: String, title: String, value: String, valueTextColor: Color? = nil, valueBackgroundColor: Color? = nil) {
        self.image = image
        self.title = title
        self.value = value
        self.valueTextColor = valueTextColor
        self.valueBackgroundColor = valueBackgroundColor
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(image)
                Text(title)
                    .bodyRegular14()
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(value)
                .bodyRegular14()
                .foregroundColor(valueTextColor ?? .white)
                .padding(.horizontal, valueBackgroundColor != nil ? 4 : 0)
                .padding(.vertical, valueBackgroundColor != nil ? 4 : 0)
                .background(valueBackgroundColor ?? .clear)
                .cornerRadius(valueBackgroundColor != nil ? 6 : 0)
        }
    }
}
