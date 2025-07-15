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
    @State private var selectedCategory: ScheduleCategory = .all
    @State private var selectedTab: Tab = .home
    @Environment(\.dismiss) private var dismiss
    
    var schedulesGrouped: [String: [String: [ScheduleModel]]] {
        let grouped = Dictionary(grouping: scheduleDummy) { model in
            let components = model.date.split(separator: ".")
            let year = components.count > 0 ? String(components[0]).trimmingCharacters(in: .whitespaces) : "기타"
            let month = components.count > 1 ? String(components[1]).trimmingCharacters(in: .whitespaces) : "기타"
            return "\(year)/\(month)"
        }
        
        return grouped.reduce(into: [String: [String: [ScheduleModel]]]()) { result, pair in
            let parts = pair.key.split(separator: "/")
            guard parts.count == 2 else { return }
            let year = String(parts[0])
            let month = String(parts[1])
            result[year, default: [:]][month, default: []] += pair.value
        }
    }
    
    var filteredSchedulesGrouped: [String: [String: [ScheduleModel]]] {
        if selectedCategory == .all {
            return schedulesGrouped
        } else {
            return schedulesGrouped.mapValues { months in
                months.mapValues { schedules in
                    schedules.filter { schedule in
                        // 추후 필터링 로직 추가
                        return true
                    }
                }
            }
        }
    }
    
    private var sortedYears: [String] {
        filteredSchedulesGrouped.keys.sorted(by: <)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    headerView
                    categoryScrollView
                    scheduleContentView
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.black.ignoresSafeArea())
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
            selectedCategory = category
        }) {
            Text(category.displayName)
                .bodyMedium16()
                .foregroundColor(selectedCategory == category ? .black : .gray300)
                .frame(height: 40)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedCategory == category ? .gray100 : .gray700)
                )
        }
    }
    
    private var scheduleContentView: some View {
        ForEach(sortedYears, id: \.self) { year in
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
        let months = filteredSchedulesGrouped[year] ?? [:]
        let sortedMonths = months.keys.sorted()
        
        return ForEach(sortedMonths, id: \.self) { month in
            monthSectionView(month: month, schedules: months[month] ?? [])
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
}


