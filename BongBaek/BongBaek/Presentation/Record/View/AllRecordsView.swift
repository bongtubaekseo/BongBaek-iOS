//
//  AllRecordsView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct AllRecordsView: View {
    let event: Event?
    @State private var isDetailExpanded = false
    @State private var memoText = ""
    @State private var keyboardHeight: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                
                HStack {
                    Button(action: {
                        dismiss()
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
                        // 편집 액션
                    }) {
                        Image("icon_edit")
                            .foregroundColor(.white)
                    }
                    .contentShape(Rectangle())
                    .padding(.trailing, 20)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                
                if let event = event {
                    VStack(spacing: 12) {
                        VStack {
                            Text("\(event.hostInfo.hostName)의 \(event.eventInfo.eventCategory)")
                                .titleSemiBold16()
                                .foregroundStyle(.white)
                                
                            Text(event.eventInfo.eventDate)
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
                            
                            Text("\(event.eventInfo.cost.formatted())원")
                                .titleSemiBold18()
                                .foregroundStyle(.white)

                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(.primaryNormal),
                                    Color(hex: "#6F53FF")
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
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
                                DetailRow(image: "icon_person_16", title: "이름", value: event.hostInfo.hostName)
                                DetailRow(image: "icon_nickname_16", title: "별명", value: event.hostInfo.hostNickname)
                                DetailRow(image: "icon_event_16", title: "관계", value: event.eventInfo.relationship, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                                
                                DetailRow(image: "icon_event_16", title: "경조사", value: event.eventInfo.eventCategory, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                                DetailRow(image: "icon_event_16", title: "경조사비", value: "\(event.eventInfo.cost.formatted())원")
                                DetailRow(image: "icon_event_16", title: "참석여부", value: "참석", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                                DetailRow(image: "icon_event_16", title: "날짜", value: event.eventInfo.eventDate, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
                                DetailRow(image: "icon_location_16", title: "장소", value: event.locationInfo.location)
                                DetailRow(image: "icon_calendar", title: "D-Day", value: "D-\(event.eventInfo.dDay)", valueTextColor: .red, valueBackgroundColor: .red.opacity(0.2))
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
                            // 삭제 액션 구현
                            deleteEvent()
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
                } else {
                    // 이벤트가 없을 때 처리
                    VStack {
                        Text("이벤트 정보를 불러올 수 없습니다")
                            .foregroundColor(.gray)
                        Button("돌아가기") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
        }
        .background(Color.background)
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - Actions
    private func deleteEvent() {
        guard let event = event else { return }
        
        // 삭제 확인 알럿 표시
        // 실제 삭제 API 호출
        // EventManager.shared.deleteEvent(eventId: event.eventId) { success, error in
        //     if success {
        //         dismiss()
        //     }
        // }
        
        print("이벤트 삭제: \(event.eventId)")
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


