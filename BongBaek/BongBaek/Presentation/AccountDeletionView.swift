//
//  AccountDeletionView.swift
//  BongBaek
//
//  Created by 임재현 on 8/28/25.
//

import SwiftUI

struct AccountDeletionView: View {
    
    @State private var selectedReason: String? = nil
    
    let deletionReasons = [
        "사용이 불편했어요",
        "개인정보가 걱정돼요",
        "앱을 자주 사용하지 않아요",
        "오류나 문제가 있었어요",
        "새로운 계정으로 사용하고 싶어요",
        "기타"
    ]
    var body: some View {
        
        VStack(spacing: 0) {
            CustomNavigationBar(title: "서비스 탈퇴") {
                print("123")
            }
            
            VStack(alignment: .leading,spacing: 12) {
                Text("탈퇴를 도와드릴게요")
                    .font(.head_bold_24)
                    .foregroundStyle(.gray100)
                
                Text("더 나은 서비스를 위해 탈퇴 이유을 알려주세요")
                    .font(.body2_regular_14)
                    .foregroundStyle(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding(.leading, 20)
            
            VStack(spacing: 12) {
                ForEach(deletionReasons, id: \.self) { reason in
                    DeletionReasonButton(
                        title: reason,
                        isSelected: selectedReason == reason,
                        hasAnySelection: selectedReason != nil
                    ) {
                        selectReason(reason: reason)
                    }
                }
            }
            .padding(20)
            .background(.gray800)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            Spacer()
            
            Button(action: {
                handleAccountDeletion()
            }) {
                Text("탈퇴하기")
                    .font(.title_semibold_18)
                    .foregroundColor(selectedReason != nil ? .white : .gray500)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedReason != nil ? .primaryNormal : .primaryBg)
                    )
            }
            .disabled(selectedReason == nil)
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: selectedReason != nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
             
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)

    }

    private func selectReason(reason: String) {
        selectedReason = selectedReason == reason ? nil : reason
    }
    
    private func handleAccountDeletion() {
        guard let reason = selectedReason else { return }
        
        print("선택된 탈퇴 이유: \(reason)")
    }
}


struct DeletionReasonButton: View {
    let title: String
    let isSelected: Bool
    let hasAnySelection: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
  
                Image(getImageName())
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isSelected ? .blue : .gray400)
                    .frame(width: 24,height: 24)
                
                Text(title)
                    .font(.body1_medium_16)
                    .foregroundColor(.gray100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(.gray750)
        }
        .overlay(
             RoundedRectangle(cornerRadius: 8)
                 .stroke(
                     isSelected ? .primaryNormal : .gray600,
                     lineWidth: 2
                 )
         )
         .cornerRadius(8)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private func getImageName() -> String {
        if !hasAnySelection {
            return "icon_check"
        } else {
            return isSelected ? "icon_colorcheck" : "icon_come_16"
        }
    }
}

