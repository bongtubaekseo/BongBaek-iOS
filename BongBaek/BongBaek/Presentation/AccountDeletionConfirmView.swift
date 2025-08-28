//
//  AccountDeletionConfirmView.swift
//  BongBaek
//
//  Created by 임재현 on 8/28/25.
//

import SwiftUI

struct AccountDeletionConfirmView: View {
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "서비스 탈퇴") {
                print("123")
            }
            
            VStack(alignment: .leading,spacing: 12) {
                Text("소중한 의견 감사합니다")
                    .font(.head_bold_24)
                    .foregroundStyle(.gray100)
                
                Text("봉투백서는 다시 만나는 날을 기원해요")
                    .font(.body2_regular_14)
                    .foregroundStyle(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10.adjustedH)
            .padding(.leading, 20)
            
            Image("image_gift")
                .frame(width: 335.adjusted,height: 335.adjustedH)
                .padding(.top,20.adjustedH)
            
            Button {
//                router.push(to: .recommendView)
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
            .padding(.top, 20.adjustedH)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
    }
}

#Preview {
    AccountDeletionConfirmView()
}
