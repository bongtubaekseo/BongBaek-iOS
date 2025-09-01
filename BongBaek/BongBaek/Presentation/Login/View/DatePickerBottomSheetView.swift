//
//  DatePickerBottomSheetView.swift
//  BongBaek
//
//  Created by 임재현 on 7/1/25.
//

import SwiftUI

struct DatePickerBottomSheetView: View {
    let minYearOffset: Int?
    let maxYearOffset: Int?
    let onComplete: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    
    init(onComplete: @escaping (String) -> Void) {
        self.minYearOffset = -100
        self.maxYearOffset = -14
        self.onComplete = onComplete
    }
    
    init(minYearOffset: Int?, maxYearOffset: Int?, onComplete: @escaping (String) -> Void) {
        self.minYearOffset = minYearOffset
        self.maxYearOffset = maxYearOffset
        self.onComplete = onComplete
    }
    
    static func pastOnly(years: Int = 100, onComplete: @escaping (String) -> Void) -> DatePickerBottomSheetView {
        DatePickerBottomSheetView(minYearOffset: -years, maxYearOffset: 0, onComplete: onComplete)
    }
    
    static func futureOnly(years: Int = 10, onComplete: @escaping (String) -> Void) -> DatePickerBottomSheetView {
        DatePickerBottomSheetView(minYearOffset: 0, maxYearOffset: years, onComplete: onComplete)
    }
    
    static func unlimited(onComplete: @escaping (String) -> Void) -> DatePickerBottomSheetView {
        DatePickerBottomSheetView(minYearOffset: nil, maxYearOffset: nil, onComplete: onComplete)
    }
    
    private var dateRange: ClosedRange<Date>? {
        guard let minYearOffset = minYearOffset, let maxYearOffset = maxYearOffset else {
            return nil
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let minDate = calendar.date(byAdding: .year, value: minYearOffset, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: maxYearOffset, to: currentDate) ?? currentDate
        
        return minDate...maxDate
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 16)

            Group {
                if let dateRange = dateRange {
                    DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                } else {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                }
            }
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .preferredColorScheme(.dark)
            .accentColor(.blue)
            .padding(.horizontal, 20)
            
            
            Spacer()
            
            Button {
                let formattedDate = dateFormatter.string(from: selectedDate)
                onComplete(formattedDate)
                dismiss()
            } label: {
                Text("선택완료")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.primaryNormal)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(.gray750)
        .onAppear {
            setInitialDate()
        }
    }
    
    private func setInitialDate() {
        guard let minYearOffset = minYearOffset,
              let maxYearOffset = maxYearOffset else {
            return
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        if maxYearOffset < 0 {
            // 과거 날짜만 가능
            selectedDate = calendar.date(byAdding: .year, value: maxYearOffset, to: currentDate) ?? currentDate
        } else if minYearOffset > 0 {
            // 미래 날짜만 가능
            selectedDate = calendar.date(byAdding: .year, value: minYearOffset, to: currentDate) ?? currentDate
        }
    }
}
