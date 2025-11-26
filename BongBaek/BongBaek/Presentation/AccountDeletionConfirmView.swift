//
//  AccountDeletionConfirmView.swift
//  BongBaek
//
//  Created by 임재현 on 8/28/25.
//

import SwiftUI

struct AccountDeletionConfirmView: View {
    
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading,spacing: 12) {
                Text("소중한 의견 감사합니다")
                    .font(.head_bold_24)
                    .foregroundStyle(.txtDisplaySecondary)
                
                Text("봉투백서는 다시 만나는 날을 기원해요")
                    .font(.body2_regular_14)
                    .foregroundStyle(.txtDisplayTierary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40.adjustedH)
            .padding(.leading, 20)
            
            Image("img_leave")
                .frame(width: 335.adjusted,height: 335.adjustedH)
                .padding(.top,80.adjustedH)
            
            Spacer()
            
            Button {
                AuthManager.shared.completeWithdrawal()
            } label: {
                HStack {
                    Spacer()
                    Text("종료")
                        .titleSemiBold18()
                        .foregroundStyle(.txtInteractiveInverse)
                    Spacer()
                }
                .frame(height: 55)
                .background(.bgStatusFocused)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60.adjustedH)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bgDisplayPrimary)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)

    }
}
