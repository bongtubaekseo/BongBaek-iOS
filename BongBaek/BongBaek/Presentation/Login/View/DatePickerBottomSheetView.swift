//
//  DatePickerBottomSheetView.swift
//  BongBaek
//
//  Created by 임재현 on 7/1/25.
//

import SwiftUI

struct DatePickerBottomSheetView: View {
    let onComplete: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    
    private var dateRange: ClosedRange<Date> {
            let calendar = Calendar.current
            let currentDate = Date()
        
            let minDate = calendar.date(byAdding: .year, value: -100, to: currentDate) ?? currentDate
            let maxDate = calendar.date(byAdding: .year, value: -14, to: currentDate) ?? currentDate
            
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

            DatePicker(
                     "",
                     selection: $selectedDate,
                     in: dateRange,
                     displayedComponents: .date
                 )
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
    }
}

