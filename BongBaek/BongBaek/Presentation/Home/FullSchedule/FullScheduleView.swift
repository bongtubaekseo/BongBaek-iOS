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
    
    var emptyMessage: String {
            switch selectedCategory {
            case .babyParty:
                return "돌잔치가 없습니다"
            case .wedding, .birthday, .funeral:
                return "참석한 \(selectedCategory.displayName)이 없습니다"
            case .all:
                return "기록한 경조사가 없습니다. "
            }
        }
    
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
                        schedule.type == selectedCategory.rawValue // 추후 type 대신 eventCategory필요
                    }
                }
                .filter{ !$0.value.isEmpty}
            }
            .filter{ !$0.value.isEmpty}
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ScheduleCategory.allCases, id: \.self) { category in
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
                            }
                            .padding(.horizontal, 4)
                        }
                    }

                    if filteredSchedulesGrouped.isEmpty{
                        RecordsEmptyView(message: "참석한 경조사가 없습니다")
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .padding(.top, 40)
                    } else{
                        ForEach(filteredSchedulesGrouped.keys.sorted(by: <), id: \.self) { year in
                            VStack(alignment: .leading, spacing: 16) {
                                Text("\(year)년")
                                    .headBold24()
                                    .foregroundColor(.white)

                                let months = filteredSchedulesGrouped[year] ?? [:]
                                ForEach(months.keys.sorted(), id: \.self) { month in
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

                                        ForEach(months[month] ?? []) { schedule in
                                            FullScheduleCellView(model: schedule)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
//            
//            CustomTabView(selectedTab: $selectedTab)
//                .background(Color.gray750)
//                .clipShape(
//                    .rect(
//                        topLeadingRadius: 10,
//                        topTrailingRadius: 10
//                    )
//                )
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    FullScheduleView()
}
