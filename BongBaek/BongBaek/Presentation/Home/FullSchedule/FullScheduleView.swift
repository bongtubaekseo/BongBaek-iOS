//
//  FullScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

enum ScheduleCategory: String, CaseIterable {
    case all = "전체"
    case wedding = "결혼식"
    case babyParty = "돌잔치"
    case birthday = "생일"
    case funeral = "장례식"
    
    var displayName: String {
        return self.rawValue
    }
}

struct FullScheduleView: View {
    @StateObject private var viewModel = FullScheduleViewModel()
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 30) {
                    headerView
                    categoryScrollView
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.hasError {
                        errorView
                    } else if viewModel.hasData {
                        eventContentView
                    } else {
                        emptyView
                    }
                    
                    if viewModel.isLoadingMore {
                        loadingMoreView
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadAllEvents()
            }
        }
        .refreshable {
            Task {
                await viewModel.refreshEvents()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
            }
            .contentShape(Rectangle())
            
            Text("봉백님의 전체 일정")
                .titleSemiBold18()
                .foregroundColor(.white)
                .padding(.leading, 12)
            
            Spacer()
        }
    }
    
    private var categoryScrollView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ScheduleCategory.allCases, id: \.self) { category in
                        categoryButton(for: category)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func categoryButton(for category: ScheduleCategory) -> some View {
        Button(action: {
            viewModel.updateCategory(category)
        }) {
            Text(category.displayName)
                .bodyMedium16()
                .foregroundColor(viewModel.selectedCategory == category ? .black : .gray300)
                .frame(height: 40)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedCategory == category ? .gray100 : .gray700)
                )
        }
    }
    
    // 🔄 eventContentView로 변경
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
            .padding(.trailing, 20)
            
            ForEach(events, id: \.eventId) { event in
                EventCellView(event: event)
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
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryNormal)
            Text("일정을 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
    
    // 추가 로딩 뷰
    private var loadingMoreView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryNormal))
                .scaleEffect(0.8)
            
            Text("더 많은 일정을 불러오는 중...")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다")
                .bodyRegular14()
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
            
            Button("다시 시도") {
                Task {
                    await viewModel.loadAllEvents()
                }
            }
            .foregroundColor(.primaryNormal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(.gray400)
            
            Text("일정이 없습니다")
                .bodyRegular14()
                .foregroundColor(.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
}


struct EventCellView: View {
    let event: AttendedEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 이벤트 카테고리
                Text(event.eventInfo.eventCategory)
                    .bodyMedium14()
                    .foregroundColor(.primaryNormal)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.primaryNormal.opacity(0.1))
                    )
                
                Spacer()
                
                // 날짜
                Text(formatDate(event.eventInfo.eventDate))
                    .captionRegular12()
                    .foregroundColor(.gray400)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // 호스트 이름
                    Text(event.hostInfo.hostName)
                        .titleSemiBold16()
                        .foregroundColor(.white)
                    
                    // 관계
                    Text(event.eventInfo.relationship)
                        .captionRegular12()
                        .foregroundColor(.gray400)
                }
                
                Spacer()
                
                // 금액
                Text(formatMoney(event.eventInfo.cost))
                    .titleSemiBold16()
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray750)
        )
    }
    
    // 날짜 포맷팅: "2025-01-18" → "1월 18일"
    private func formatDate(_ dateString: String) -> String {
        let components = dateString.split(separator: "-")
        if components.count >= 3 {
            let month = Int(components[1]) ?? 1
            let day = Int(components[2]) ?? 1
            return "\(month)월 \(day)일"
        }
        return dateString
    }
    
    // 금액 포맷팅: 1000000 → "100만원"
    private func formatMoney(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(formattedAmount)원"
    }
}


