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
    @State private var isOtherReasonExpanded = false
    
    let deletionReasons = [
        "사용이 불편했어요",
        "개인정보가 걱정돼요",
        "앱을 자주 사용하지 않아요",
        "오류나 문제가 있었어요",
        "새로운 계정으로 사용하고 싶어요",
        "기타"
    ]
    
    var displayedReasons: [String] {
        if isOtherReasonExpanded {
            return ["기타"]
        } else {
            return deletionReasons
        }
    }
    
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
            
            ScrollViewReader { proxy in
                VStack(spacing: 12.adjustedH) {
                    ForEach(displayedReasons, id: \.self) { reason in
                        DeletionReasonButton(
                            title: reason,
                            isSelected: selectedReason == reason,
                            hasAnySelection: selectedReason != nil,
                            action: { selectReason(reason: reason) },
                            otherReasonText: $otherReasonText,
                            isTextFieldFocused: $isTextFieldFocused,
                            isOtherReasonExpanded: $isOtherReasonExpanded
                        )
                        .id(reason)
                    }
                }
                .padding(20)
                .background(.gray800)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 20.adjustedH)
                .animation(.easeInOut(duration: 0.3), value: displayedReasons)
                .onChange(of: isOtherReasonExpanded) { _, newValue in
                    print("확장 상태 변경: \(newValue)")
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("기타", anchor: .top)
                        }
                    }
                }
                .onChange(of: isTextFieldFocused) { _, newValue in
                    print("포커스 상태 변경: \(newValue)")
                    if newValue && selectedReason == "기타" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("기타", anchor: .top)
                            }
                        }
                    }
                }
            }
            
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
            if isOtherReasonExpanded {
                collapseOtherReason()
            }
        }
        .onChange(of: isTextFieldFocused) { _, newValue in
            if !newValue && isOtherReasonExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    collapseOtherReason()
                }
            }
        }
        .onChange(of: otherReasonText) { _, newValue in
            if newValue.count >= 50 && isOtherReasonExpanded {
                collapseOtherReason()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)

    }

    private func selectReason(reason: String) {
        if selectedReason == reason {
            if reason != "기타" {
                selectedReason = nil
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isOtherReasonExpanded = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isTextFieldFocused = true
                }
            }
        } else {
            selectedReason = reason
            if reason == "기타" {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isOtherReasonExpanded = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isTextFieldFocused = true
                }
            } else {
                otherReasonText = ""
                isOtherReasonExpanded = false
            }
        }
    }
    
    private func collapseOtherReason() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isOtherReasonExpanded = false
        }
        isTextFieldFocused = false
    }

    private func handleAccountDeletion() {
        if isOtherReasonExpanded {
            collapseOtherReason()
        }
        
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
    @Binding var isOtherReasonExpanded: Bool // 추가
    
    var body: some View {
        if title == "기타" {
            if isSelected && isOtherReasonExpanded {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
          
                        Image(getImageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("기타")
                            .font(.body1_medium_16)
                            .foregroundColor(.gray100)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOtherReasonExpanded = false
                        }
                        isTextFieldFocused = false
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("기타 사유를 입력해주세요",
                                  text: $otherReasonText,
                                  prompt: Text("기타 사유를 입력해주세요")
                            .foregroundColor(.gray500),
                                  axis: .vertical)
                              
                            .font(.body1_medium_16)
                            .foregroundColor(.white)
                            .focused($isTextFieldFocused)
                            .lineLimit(3...6)
                            .onSubmit {
                                isTextFieldFocused = false
                            }
                            .onChange(of: otherReasonText) { oldValue, newValue in
                                if newValue.contains("\n") {
                                    otherReasonText = newValue.replacingOccurrences(of: "\n", with: "")
                                    isTextFieldFocused = false
                                    return
                                }
                                
                                if newValue.count > 50 {
                                    otherReasonText = String(newValue.prefix(50))
                                }
                            }
                        
                        HStack {
                            Spacer()
                            Text("\(otherReasonText.count)/50")
                                .font(.caption)
                                .foregroundColor(.gray500)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(.gray750)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primaryNormal, lineWidth: 1)
                )
                .cornerRadius(8)
            } else {
                Button(action: {
                    if isSelected {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOtherReasonExpanded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isTextFieldFocused = true
                        }
                    } else {
                        action()
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(getImageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text(otherReasonText.isEmpty ? "기타" : otherReasonText)
                            .font(.body1_medium_16)
                            .foregroundColor(.gray100)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(.gray750)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? Color.primaryNormal : Color.gray750,
                                lineWidth: 1
                            )
                    )
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
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
                            isSelected ? Color.primaryNormal : Color.gray750,
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
