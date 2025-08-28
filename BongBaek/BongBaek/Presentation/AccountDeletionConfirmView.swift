//
//  AccountDeletionConfirmView.swift
//  BongBaek
//
//  Created by 임재현 on 8/28/25.
//

import SwiftUI

struct AccountDeletionConfirmView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @State private var showDeleteAlert = false
    @State private var showCompletionAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "서비스 탈퇴") {
                print("123")
                router.pop()
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
                showDeleteAlert = true
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
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert("정말 탈퇴하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {
                
            }
            Button("탈퇴", role: .destructive) {
                showCompletionAlert = true
            }
        } message: {
            Text("탈퇴시 데이터 복구가 어렵습니다.")
        }
        .alert("탈퇴가 완료되었습니다!", isPresented: $showCompletionAlert) {
             Button("확인") {
                 // TODO: 회원 탈퇴 진행 및 로그인 화면으로 이동 로직 추가
                 print("탈퇴 완료")
             }
         } message: {
             Text("그동안 봉투백서를 이용해주셔서 감사했습니다.")
         }
    }
}

#Preview {
    AccountDeletionConfirmView()
}
