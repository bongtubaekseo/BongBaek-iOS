//
//  FullScheduleView.swift
//  BongBaek
//
//  Created by hyunwoo on 7/2/25.
//
import SwiftUI

struct FullScheduleView: View {
    
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
            VStack(alignment: .leading, spacing: 50) {
                Text("봉백님의 전체 일정")
                    .titleSemiBold18()
                    .foregroundColor(.white)

                ForEach(schedulesGrouped.keys.sorted(by: <), id: \.self) { year in
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(year)년")
                            .headBold24()
                            .foregroundColor(.white)

                        let months = schedulesGrouped[year] ?? [:]
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
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
#Preview {
    FullScheduleView()
}
