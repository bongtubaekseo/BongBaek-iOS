//
//  FullScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct FullScheduleView: View {
    // 연도 → 월 → 일정 목록 형태로 정리
    var schedulesGrouped: [String: [String: [ScheduleModel]]] {
        let grouped = Dictionary(grouping: scheduleDummy) { model in
            let components = model.date.split(separator: ".")
            let year = components[safe: 0].map { String($0).trimmingCharacters(in: .whitespaces) } ?? "기타"
            let month = components[safe: 1].map { String($0).trimmingCharacters(in: .whitespaces) } ?? "기타"
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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("봉백님의 전체 일정")
                    .font(.title)
                    .foregroundColor(.white)

                ForEach(schedulesGrouped.keys.sorted(by: >), id: \.self) { year in
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(year)년")
                            .font(.title2).bold()
                            .foregroundColor(.white)

                        let months = schedulesGrouped[year] ?? [:]
                        ForEach(months.keys.sorted(), id: \.self) { month in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(Int(month) ?? 0)월")
                                    .font(.headline)
                                    .foregroundColor(.gray)

                                ForEach(months[month] ?? []) { schedule in
                                    FullScheduleCellView(model: schedule)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Array의 safe subscript extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    FullScheduleView()
}
