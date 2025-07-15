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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    headerView
                    categoryScrollView
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.hasError {
                        errorView
                    } else if viewModel.hasData {
                        scheduleContentView
                    } else {
                        emptyView
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
                await viewModel.loadAllSchedules()
            }
        }
        .refreshable {
            Task {
                await viewModel.refreshSchedules()
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
    
    private var scheduleContentView: some View {
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
            if let schedules = months[month], !schedules.isEmpty {
                monthSectionView(month: month, schedules: schedules)
            }
        }
    }
    
    private func monthSectionView(month: String, schedules: [ScheduleModel]) -> some View {
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
            
            ForEach(schedules) { schedule in
                FullScheduleCellView(model: schedule)
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
                    await viewModel.loadAllSchedules()
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


