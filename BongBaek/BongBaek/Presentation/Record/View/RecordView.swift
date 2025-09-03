//
//  RecordView.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//

import SwiftUI

enum EventsCategory: String, CaseIterable {
    case all = "전체"
    case wedding = "결혼식"
    case babyParty = "돌잔치"
    case birthday = "생일"
    case funeral = "장례식"
    
    var display: String {
        return self.rawValue
    }
}

struct RecordView: View {
    @StateObject private var viewModel = RecordViewModel()
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RecordsHeaderView(
                    isDeleteMode: $viewModel.isDeleteMode,
                    onDeleteTapped: {
                        viewModel.deleteSelectedRecords()
                    }
                )
                .environmentObject(router)
                
                RecordSectionHeaderView(
                    selectedSection: $viewModel.selectedSection,
                    attendedCount: viewModel.attendedCount,
                    notAttendedCount: viewModel.notAttendedCount,
                    onSectionChange: { section in
                        viewModel.changeSection(to: section)
                    }
                )
                .padding(.bottom, 20)
                
                CategoryFilterView(
                    selectedCategory: $viewModel.selectedCategory,
                    onCategoryChange: { category in
                        viewModel.changeCategory(to: category)
                    }
                )
                .padding(.leading, 20)
                
                RecordContentView(
                    viewModel: viewModel
                )
            }
        }
        .background(Color.background)
        .onAppear {
            Task {
                await viewModel.loadAllRecords()
            }
        }
        .refreshable {
            Task {
                await viewModel.refreshRecords()
            }
        }
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: EventsCategory
    let onCategoryChange: (EventsCategory) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventsCategory.allCases, id: \.self) { category in
                    Button(action: {
                        onCategoryChange(category)
                    }) {
                        Text(category.display)
                            .bodyMedium14()
                            .foregroundColor(selectedCategory == category ? .black : .gray300)
                            .frame(height: 40)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedCategory == category ? .gray100 : .gray700)
                            )
                    }
                }
            }
        }
    }
}


struct RecordsHeaderView: View {
    @Binding var isDeleteMode: Bool
    let onDeleteTapped: () -> Void
    @State private var showAlert = false
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack {
            HStack {
                if isDeleteMode {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDeleteMode = false
                        }
                    }) {
                        Text("취소")
                            .bodyRegular16()
                            .foregroundColor(.white)
                    }
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    Text("경조사 전체 기록")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    
                    Spacer()
                }
            }
            
            if isDeleteMode {
                Spacer()
                
                Text("경조사 기록 삭제")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                
                Spacer()
            }
            
      
            HStack(spacing: 0) {
                // 삭제 모드가 아닐 때만 + 버튼 표시
                if !isDeleteMode {
                    Button(action: {
                        router.push(to: .createEventView)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
                
                Button(action: {
                    if isDeleteMode {
                        showAlert = true
                    } else {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDeleteMode = true
                        }
                    }
                }) {
                    if isDeleteMode {
                        Text("삭제")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .alert("경조사 기록을 삭제하겠습니까?", isPresented: $showAlert) {
                    Button("취소", role: .cancel) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDeleteMode = false
                        }
                    }
                    Button("삭제", role: .destructive) {
                        onDeleteTapped()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDeleteMode = false
                        }
                    }
                } message: {
                    Text("이 기록의 모든 내용이 삭제됩니다.")
                        .bodyRegular14()
                        .foregroundStyle(.gray600)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .animation(.easeInOut(duration: 0.2), value: isDeleteMode)
    }
}


struct RecordSectionHeaderView: View {
    @Binding var selectedSection: RecordSection
    let attendedCount: Int
    let notAttendedCount: Int
    let onSectionChange: (RecordSection) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // 참석했어요 탭
            Button(action: {
                onSectionChange(.attended)
            }) {
                VStack(spacing: 8) {
                    HStack {
                        Text("참석했어요")
                            .titleSemiBold16()
                            .foregroundColor(selectedSection == .attended ? .white : .gray)
                    }
                    
                    Rectangle()
                        .fill(selectedSection == .attended ? .blue : .clear)
                        .frame(height: 1)
                }
            }
            .frame(maxWidth: .infinity)
            
            // 불참했어요 탭
            Button(action: {
                onSectionChange(.notAttended)
            }) {
                VStack(spacing: 8) {
                    HStack {
                        Text("불참했어요")
                            .titleSemiBold16()
                            .foregroundColor(selectedSection == .notAttended ? .white : .gray)
                    }
                    
                    Rectangle()
                        .fill(selectedSection == .notAttended ? .blue : .clear)
                        .frame(height: 1)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct RecordContentView: View {
    @ObservedObject var viewModel: RecordViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView2()
            } else if viewModel.isCurrentSectionEmpty {
                RecordsEmptyView(message: viewModel.emptyMessage)
            } else {
                // 🆕 년도/월별 그루핑 표시
                eventContentView
                
                // 🆕 추가 로딩 인디케이터
                if viewModel.isLoadingMore {
                    HStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .primaryNormal))
                            .scaleEffect(0.8)
                        
                        Text("더 많은 기록을 불러오는 중...")
                            .bodyRegular14()
                            .foregroundColor(.gray400)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
        }
        .padding(.top, 20)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedSection)
    }
    
    private var eventContentView: some View {
        ForEach(viewModel.sortedYears, id: \.self) { year in
            yearSectionView(for: year)
        }
    }
    
    private func yearSectionView(for year: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(year)년")
                .headBold24()
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            monthsView(for: year)
        }
    }
    
    private func monthsView(for year: String) -> some View {
        let months = viewModel.monthsForYear(year)
        let sortedMonths = viewModel.sortedMonthsForYear(year)
        
        return ForEach(sortedMonths, id: \.self) { month in
            if let events = months[month], !events.isEmpty {
                monthSectionView(month: month, events: events)
            }
        }
    }
    
    private func monthSectionView(month: String, events: [AttendedEvent]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Text("\(Int(month) ?? 0)월")
                    .titleSemiBold16()
                    .foregroundColor(.white)
                
                Rectangle()
                    .foregroundColor(.gray750)
                    .frame(height: 2)
            }
            .padding(.horizontal, 20)
            .padding(.trailing, 20)
            
            ForEach(events, id: \.eventId) { event in
                RecordCellView(
                    event: event,
                    isDeleteMode: viewModel.isDeleteMode,
                    isSelected: viewModel.selectedRecordIDs.contains(event.eventId),
                    onSelectionToggle: {
                        viewModel.toggleRecordSelection(event.eventId)
                    }
                )
                .onAppear {
                    // 무한스크롤
                    if viewModel.shouldLoadMore(for: event) {
                        Task {
                            await viewModel.loadMoreEvents()
                        }
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

struct RecordsEmptyView: View {
    let message: String
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(alignment: .center) {
            Text(message)
                .headBold24()
                .foregroundColor(.white)
            
            Text("지금 경조사를 기록하고")
                .bodyRegular14()
                .foregroundColor(.gray300)
                .padding(.top, 16)
            
            Text("상황에 어울리는 경조사비까지 추천받으세요")
                .bodyRegular14()
                .foregroundColor(.gray300)
            
            Image("Mask Group 5")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding(.top, 16)
            
            Button(action: {
                router.push(to: .createEventView)
            }) {
                Text("지금 기록하기")
                    .titleSemiBold16()
                    .foregroundColor(.white)
                    .frame(width: 145)
                    .frame(height: 40)
            }
            .background(.primaryNormal)
            .cornerRadius(6)
            .padding(.horizontal, 40)
            .padding(.top, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}

struct RecordCellView: View {
    let event: AttendedEvent
    let isDeleteMode: Bool
    let isSelected: Bool
    let onSelectionToggle: () -> Void
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        HStack(spacing: 12) {
            if isDeleteMode {
                Button(action: onSelectionToggle) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .secondaryRed : .gray400)
                        .font(.system(size: 20))
                }
                .frame(width: 30)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(event.hostInfo.hostNickname)
                    .captionRegular12()
                    .foregroundColor(.primaryNormal)

                HStack {
                    Text(event.hostInfo.hostName)
                        .titleSemiBold18()
                        .foregroundColor(.white)
                    Spacer()
                    Text(formatMoney(event.eventInfo.cost))
                        .titleSemiBold18()
                        .foregroundColor(.white)
                }

                HStack {
                    HStack(spacing: 8) {
                        Text(event.eventInfo.eventCategory)
                            .captionRegular12()
                            .foregroundColor(.primaryNormal)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.primaryNormal.opacity(0.1))
                            .cornerRadius(4)
                        Text(event.eventInfo.relationship)
                            .captionRegular12()
                            .foregroundColor(.primaryNormal)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.primaryNormal.opacity(0.1))
                            .cornerRadius(4)
                    }

                    Spacer()

                    Text(formatDate(event.eventInfo.eventDate))
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.gray750)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            if !isDeleteMode { // 삭제 모드가 아닐 때만 네비게이션
                router.push(to: .allRecordView(eventId: event.eventId))

            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .animation(.easeInOut(duration: 0.3), value: isDeleteMode)
    }
    
    // MARK: - Helper Methods
    
    /// 금액 포맷팅: 1000000 → "1,000,000원"
    private func formatMoney(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(formattedAmount)원"
    }
    
    /// 날짜 포맷팅: "2025-01-18" → "2025.01.18"
    private func formatDate(_ dateString: String) -> String {
        return dateString.replacingOccurrences(of: "-", with: ".")
    }
}

struct LoadingView2: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryNormal)
            Text("기록을 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
}


enum RecordSection {
    case attended
    case notAttended
}

struct RecordModel: Identifiable {
    let id = UUID()
    let eventName: String
    let date: String
    let amount: Int
    let isAttended: Bool
    let location: String
    let relation: String
    let type: String
}
