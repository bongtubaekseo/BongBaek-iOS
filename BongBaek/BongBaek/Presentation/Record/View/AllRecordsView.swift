//
//  AllRecordsView.swift
//  BongBaek
//
//  Created by 임재현 on 7/7/25.
//

import SwiftUI

struct AllRecordsView: View {
    let eventId: String
    @StateObject private var viewModel = AllRecordsViewModel()
    @State private var isDetailExpanded = false
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
                
                
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let eventDetail = viewModel.eventDetail {
                    eventContentView(eventDetail: eventDetail)
                } else {
                    dummyContentView()
                }
            }
        }
        .background(Color.background)
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            print("AllRecordsView 진입!")
            print("받은 eventId: \(eventId)")
            print("eventId 타입: \(type(of: eventId))")
            
            Task {
                await viewModel.loadEventDetail(eventId: eventId)
            }
        }
    }
    
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryNormal)
            Text("이벤트 정보를 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text(message)
                .bodyRegular14()
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
            
            Button("다시 시도") {
                Task {
                    await viewModel.loadEventDetail(eventId: eventId)
                }
            }
            .foregroundColor(.primaryNormal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func eventContentView(eventDetail: EventDetailData) -> some View {
        VStack(spacing: 12) {
            VStack {
                Text("\(eventDetail.hostInfo.hostName)의 \(eventDetail.eventInfo.eventCategory)")
                    .titleSemiBold16()
                    .foregroundStyle(.white)
                    
                Text(eventDetail.eventInfo.eventDate)
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
                
                Text("\(eventDetail.eventInfo.cost.formatted())원")
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
            .padding(.top, 8)
            
            // 상세정보 토글 버튼
            detailToggleButton
            
            if isDetailExpanded {
                detailInfoView(eventDetail: eventDetail)
            }
            
            // 메모 섹션
            memoSection
            
            // 삭제 버튼
            deleteButton
        }
        .padding(.vertical, 16)
    }

    private func dummyContentView() -> some View {
        VStack(spacing: 12) {
            VStack {
                Text("김철수의 결혼식 (더미)")
                    .titleSemiBold16()
                    .foregroundStyle(.white)
                    
                Text("2024.12.15 (더미)")
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
                
                Text("100,000원 (더미)")
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
            .padding(.top, 8)
            
            // 상세정보 토글 버튼
            detailToggleButton
            
            if isDetailExpanded {
                dummyDetailInfoView()
            }
            
            // 메모 섹션
            memoSection
            
            // 삭제 버튼
            deleteButton
        }
        .padding(.vertical, 16)
    }
    
    private var detailToggleButton: some View {
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
    }
    
    private func detailInfoView(eventDetail: EventDetailData) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            DetailRow(image: "icon_person_16", title: "이름", value: eventDetail.hostInfo.hostName)
            DetailRow(image: "icon_nickname_16", title: "별명", value: eventDetail.hostInfo.hostNickname)
            DetailRow(image: "icon_event_16", title: "관계", value: eventDetail.eventInfo.relationship, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "경조사", value: eventDetail.eventInfo.eventCategory, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "경조사비", value: "\(eventDetail.eventInfo.cost.formatted())원")
            DetailRow(image: "icon_event_16", title: "참석여부", value: eventDetail.eventInfo.isAttend ? "참석" : "불참", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "날짜", value: eventDetail.eventInfo.eventDate, valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_location_16", title: "장소", value: eventDetail.locationInfo.location)
            DetailRow(image: "icon_calendar", title: "D-Day", value: "D-9", valueTextColor: .red, valueBackgroundColor: .red.opacity(0.2))
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
    
    private func dummyDetailInfoView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            DetailRow(image: "icon_person_16", title: "이름", value: "김철수 (더미)")
            DetailRow(image: "icon_nickname_16", title: "별명", value: "철수 (더미)")
            DetailRow(image: "icon_event_16", title: "관계", value: "친구 (더미)", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "경조사", value: "결혼식 (더미)", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "경조사비", value: "100,000원 (더미)")
            DetailRow(image: "icon_event_16", title: "참석여부", value: "참석 (더미)", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_event_16", title: "날짜", value: "2024.12.15 (더미)", valueTextColor: .blue, valueBackgroundColor: .blue.opacity(0.5))
            DetailRow(image: "icon_location_16", title: "장소", value: "강남구 웨딩홀 (더미)")
            DetailRow(image: "icon_calendar", title: "D-Day", value: "D-30 (더미)", valueTextColor: .red, valueBackgroundColor: .red.opacity(0.2))
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
    
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("메모")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                
                Spacer()
                
                // 메모 저장 버튼
//                Button("저장") {
//                    Task {
//                        await viewModel.saveMemo()
//                    }
//                }
//                .foregroundColor(.primaryNormal)
//                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            VStack(alignment: .leading) {
                TextEditor(text: $viewModel.memoText)
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
        }
    }
    
    private var deleteButton: some View {
        Button {
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
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Actions
    private func deleteEvent() {
        print("제 버튼 클릭 - eventId: \(eventId)")
        // TODO: 삭제 확인 알럿 표시 후 viewModel.deleteEvent() 호출
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


