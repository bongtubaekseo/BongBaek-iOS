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
                    .foregroundStyle(.gray100)
                
                Text("봉투백서는 다시 만나는 날을 기원해요")
                    .font(.body2_regular_14)
                    .foregroundStyle(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20.adjustedH)
            .padding(.leading, 20)
            
            Image("image_gift")
                .frame(width: 335.adjusted,height: 335.adjustedH)
                .padding(.top,80.adjustedH)
            
            Button {
                AuthManager.shared.completeWithdrawal()
            } label: {
                HStack {
                    Spacer()
                    Text("종료")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                    Spacer()
                }
                .frame(height: 55)
                .background(.primaryNormal)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40.adjustedH)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)

    }
}
