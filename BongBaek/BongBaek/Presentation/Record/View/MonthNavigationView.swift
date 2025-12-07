//
//  MonthNavigationView.swift
//  BongBaek
//
//  Created by 임재현 on 12/7/25.
//

import SwiftUI

struct MonthNavigationView: View {
    let currentYearMonth: String
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    
    var body: some View {
        HStack {
            Text(currentYearMonth)
                .headBold24()
                .foregroundColor(.txtDisplayPrimary)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.txtDisplayPrimary)
                        .frame(width: 32, height: 32)

                }
                
                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.txtDisplayPrimary)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
