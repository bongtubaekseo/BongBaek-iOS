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
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
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
                    router.push(to: .modifyEventView(mode: .edit, eventDetailData: viewModel.eventDetail))
                }) {
                    Image("icon_edit")
                        .foregroundColor(.white)
                }
                .contentShape(Rectangle())
                .padding(.trailing, 20)
            }
            .padding(.top, 20)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .padding(.bottom, 20)
            .background(Color.background) // 헤더 배경색 명시
            
            // 스크롤 가능한 콘텐츠
            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else if let eventDetail = viewModel.eventDetail {
                        eventContentView(eventDetail: eventDetail)
                    }
                }
                .padding(.top, 16) // 헤더와의 간격
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
            VStack(alignment:.leading,spacing: 10) {
                Text("\(eventDetail.hostInfo.hostName)의 \(eventDetail.eventInfo.eventCategory)")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                    
                Text(eventDetail.eventInfo.eventDate.DateFormat())
                    .bodyRegular14()
                    .foregroundStyle(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(.gray750)
            .cornerRadius(10)
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
                .padding(.top,20)
            
            if isDetailExpanded {
                detailInfoView(eventDetail: eventDetail)
            }
            
            // 메모 섹션
            memoSection
                .padding(.top,40)
            
            // 삭제 버튼
            deleteButton
                .padding(.top, 40)
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
        VStack(alignment: .leading, spacing: 36) {
            DetailRow(image: "icon_person_16", title: "이름", value: eventDetail.hostInfo.hostName)
            DetailRow(image: "icon_nickname_16", title: "별명", value: eventDetail.hostInfo.hostNickname)
            DetailRow(image: "icon_relation 2", title: "관계", value: eventDetail.eventInfo.relationship, valueTextColor: .primaryNormal, valueBackgroundColor: .primaryBg)
            DetailRow(image: "icon_event_16", title: "경조사", value: eventDetail.eventInfo.eventCategory, valueTextColor: .primaryNormal, valueBackgroundColor: .primaryBg)
            DetailRow(image: "icon_coin_16", title: "경조사비", value: "\(eventDetail.eventInfo.cost.formatted())원")
            DetailRow(image: "icon_check 1", title: "참석여부", value: eventDetail.eventInfo.isAttend ? "참석" : "불참", valueTextColor: .primaryNormal, valueBackgroundColor: .primaryBg)
            DetailRow(image: "icon_event_16", title: "날짜", value: eventDetail.eventInfo.eventDate.DateFormat(), valueTextColor: .primaryNormal, valueBackgroundColor: .primaryBg)
            DetailRow(image: "icon_location_16", title: "장소", value: eventDetail.locationInfo.location)
            //DetailRow(image: "icon_calendar", title: "D-Day", value: "D-9", valueTextColor: .red, valueBackgroundColor: .red.opacity(0.2))
        }
        .padding(20)
        .background(.gray800)
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

            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.memoText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 100, maxHeight: 200)
                    .disabled(true)

                
                if viewModel.memoText.isEmpty {
                    Text("메모가 없습니다.")
                        .bodyRegular16()
                        .foregroundColor(.gray500)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
            }
            .padding(16)
            .background(.gray800)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray800.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .padding(.horizontal, 20)
        }
    }
    
    private var deleteButton: some View {
        Button {
            showDeleteAlert = true
        } label: {
            if viewModel.isDeleting {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .scaleEffect(0.8)
                    Text("삭제 중...")
                        .titleSemiBold18()
                        .foregroundColor(.red)
                }
            } else {
                Text("기록 삭제하기")
                    .titleSemiBold18()
                    .foregroundColor(.secondaryRed)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.secondaryRed, lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.bottom,60)
        .disabled(viewModel.isDeleting)
        .alert("경조사 기록을 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                deleteEvent()
            }
        } message: {
            Text("삭제된 기록은 복구할 수 없습니다.")
        }
        .alert("삭제 완료", isPresented: $viewModel.deleteSuccess) {
            Button("확인") {
                dismiss()
//                router.pop()
            }
        } message: {
            Text("경조사 기록이 성공적으로 삭제되었습니다.")
        }
        .alert("삭제 실패", isPresented: .constant(viewModel.deleteError != nil)) {
            Button("확인") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.deleteError ?? "")
        }
    }
    
    // MARK: - Actions
    private func deleteEvent() {
        print("삭제 버튼 클릭 - eventId: \(eventId)")
        
        Task {
            let success = await viewModel.deleteEvent(eventId: eventId)
            
            if success {
                print("삭제 성공 - 이전 화면으로 이동")
            } else {
                print("삭제 실패 - 에러 메시지 표시")
            
            }
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
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.gray400)
                    .frame(width: 16,height: 16)
                Text(title)
                    .bodyMedium14()
                    .foregroundColor(.gray100)
            }
            
            Spacer()
            
            Text(value)
                .bodyMedium16()
                .foregroundColor(valueTextColor ?? .white)
                .padding(.horizontal, valueBackgroundColor != nil ? 4 : 0)
                .padding(.vertical, valueBackgroundColor != nil ? 4 : 0)
                .background(valueBackgroundColor ?? .clear)
                .cornerRadius(valueBackgroundColor != nil ? 6 : 0)
        }
    }
}
