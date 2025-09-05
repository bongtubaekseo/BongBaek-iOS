//
//  AccountDeletionView.swift
//  BongBaek
//
//  Created by 임재현 on 8/28/25.
//

import SwiftUI

struct AccountDeletionView: View {
    
    @State private var selectedReason: String? = nil
    @State private var otherReasonText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    @EnvironmentObject var router: NavigationRouter
    
    @State private var showDeleteAlert = false
    @State private var showCompletionAlert = false
    
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
                router.pop()
            }
            
            VStack(alignment: .leading,spacing: 12.adjustedH) {
                Text("탈퇴를 도와드릴게요")
                    .font(.head_bold_24)
                    .foregroundStyle(.gray100)
                
                Text("더 나은 서비스를 위해 탈퇴 이유을 알려주세요")
                    .font(.body2_regular_14)
                    .foregroundStyle(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10.adjustedH)
            .padding(.leading, 20)
            
            VStack(spacing: 12.adjustedH) {
                ForEach(deletionReasons, id: \.self) { reason in
                    DeletionReasonButton(
                        title: reason,
                        isSelected: selectedReason == reason,
                        hasAnySelection: selectedReason != nil,
                        action: { selectReason(reason: reason) },
                        otherReasonText: $otherReasonText,
                        isTextFieldFocused: $isTextFieldFocused
                    )
                }
            }
            .padding(20)
            .background(.gray800)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top, 20.adjustedH)
            
            Spacer()
            
            Button(action: {
                showDeleteAlert = true
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
            .disabled(!isDeleteButtonEnabled)
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: selectedReason != nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 40.adjustedH)
             
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
        .alert("정말 탈퇴하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {
                
            }
            Button("탈퇴", role: .destructive) {
                handleAccountDeletion()
            }
        } message: {
            Text("탈퇴시 데이터 복구가 어렵습니다.")
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)

    }

    private func selectReason(reason: String) {
        if selectedReason == reason {
            selectedReason = nil
            // 기타 선택 해제 시 텍스트도 초기화
            if reason == "기타" {
                otherReasonText = ""
            }
        } else {
            selectedReason = reason
            // 기타 선택 시 TextField에 포커스
            if reason == "기타" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            } else {
                // 다른 항목 선택 시 기타 텍스트 초기화
                otherReasonText = ""
            }
        }
    }
    
    private func handleAccountDeletion() {
        guard let reason = selectedReason else { return }
        
        let withdrawalReasonCode = mapReasonToCode(reason: reason)
        
        let detailText: String? = (reason == "기타") ? otherReasonText.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        
        let withdrawRequest = WithdrawRequestData(
            withdrawalReason: withdrawalReasonCode,
            detail: detailText
        )
        
        print("전송할 데이터: \(withdrawRequest)")
        
        AuthManager.shared.withdraw(reason: withdrawRequest) { success in
            DispatchQueue.main.async {
                if success {
                    router.push(to: .accountDeletionConfirmView)
                } else {
                    print("탈퇴 처리 실패")
                }
            }
        }
    }
    
    private var isDeleteButtonEnabled: Bool {
        guard let reason = selectedReason else { return false }
        
        if reason == "기타" {
            let trimmedText = otherReasonText.trimmingCharacters(in: .whitespacesAndNewlines)
                return !trimmedText.isEmpty && trimmedText.count >= 1 && trimmedText.count <= 50
        } else {
            return true
        }
    }
    
    private func mapReasonToCode(reason: String) -> String {
        switch reason {
        case "사용이 불편했어요":
            return "INCONVENIENT"
        case "개인정보가 걱정돼요":
            return "PRIVACY_CONCERN"
        case "앱을 자주 사용하지 않아요":
            return "RARELY_USED"
        case "오류나 문제가 있었어요":
            return "BUG_OR_ERROR"
        case "새로운 계정으로 사용하고 싶어요":
            return "NEW_ACCOUNT"
        case "기타":
            return "OTHER"
        default:
            return "OTHER"
        }
    }
}


struct DeletionReasonButton: View {
    let title: String
    let isSelected: Bool
    let hasAnySelection: Bool
    let action: () -> Void
    @Binding var otherReasonText: String
    @FocusState.Binding var isTextFieldFocused: Bool
    
    var body: some View {
        if title == "기타" && isSelected {

            HStack(spacing: 12) {
  
                Image(getImageName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                TextField("기타 사유를 입력해주세요",
                          text: $otherReasonText,
                          prompt: Text("기타 사유를 입력해주세요")
                    .foregroundColor(.gray500))
                      
                    .font(.body1_medium_16)
                    .foregroundColor(.white)
                    .focused($isTextFieldFocused)
                    .onChange(of: otherReasonText) { oldValue, newValue in
                         if newValue.count > 50 {
                             otherReasonText = String(newValue.prefix(50))
                         }
                     }
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(.gray750)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primaryNormal, lineWidth: 1)
            )
            .cornerRadius(8)
        } else {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(getImageName())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(title)
                        .font(.body1_medium_16)
                        .foregroundColor(.gray100)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(.gray750)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isSelected ? Color.primaryNormal : Color.gray600,
                            lineWidth: 1
                        )
                )
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
    
    private func getImageName() -> String {
        if !hasAnySelection {
            return "icon_check"
        } else {
            return isSelected ? "icon_colorcheck" : "icon_come_16"
        }
    }
}

