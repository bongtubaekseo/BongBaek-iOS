//
//  SignUpBottomSheetView.swift
//  BongBaek
//
//  Created by 임재현 on 6/30/25.
//

import SwiftUI

struct SignUpBottomSheetView: View {
    let onComplete: () -> Void
    @State private var allAgree = false
    @State private var ageAgree = false
    @State private var serviceAgree = false
    @State private var privacyAgree = false
    @Environment(\.dismiss) private var dismiss
    @State var isChecked = false
    
    private var canProceed: Bool {
        ageAgree && serviceAgree && privacyAgree
    }
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading,spacing: 4){
                    Text("앱 사용을 위해 권한을 허용해주세요.")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                    Text("서비스 이용에 필수적인 약관들이에요.")
                        .titleSemiBold18()
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    CheckButton(
                        title: "서비스 이용 약관 전체 동의",
                        isRequired: nil,
                        isChecked: $allAgree,
                        manualToggle: true,
                        onTap: {
                            print("전체 동의 버튼 클릭됨")
                            print("전체 동의 클릭 전 상태: allAgree=\(allAgree)")
                            toggleAllAgree()
                        }
                    )
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        CheckButton(
                            title: "만 14세 이상",
                            isRequired: true,
                            isChecked: $ageAgree,
                            onTap: {
                                print("만 14세 이상 버튼 클릭됨")
                                print("클릭 후 ageAgree: \(ageAgree)")
                                updateAllAgreeStatus()
                            }
                        )
                        
                        CheckButton(
                            title: "서비스 이용약관 동의",
                            isRequired: true,
                            isChecked: $serviceAgree,
                            hasDetailButton: true,
                            onTap: {
                                print("서비스 이용약관 버튼 클릭됨")
                                print("클릭 후 serviceAgree: \(serviceAgree)")
                                updateAllAgreeStatus()
                            },
                            onDetailTap: {
                                print("서비스 약관 상세보기 클릭됨")
                            }
                        )
                        
                        CheckButton(
                            title: "개인정보 보호 정책",
                            isRequired: true,
                            isChecked: $privacyAgree,
                            hasDetailButton: true,
                            onTap: {
                                print("개인정보 보호 정책 버튼 클릭됨")
                                print("클릭 후 privacyAgree: \(privacyAgree)")
                                updateAllAgreeStatus()
                            },
                            onDetailTap: {
                                print("개인정보 약관 상세보기 클릭됨")
                            }
                        )
                    }
                }
                .padding(.top, 12)

                Spacer()
                
                Button(action: {
                    print("허용하고 계속하기 버튼 클릭됨")
                    print("canProceed: \(canProceed)")
                    onComplete()
                }) {
                    HStack {
                        Spacer()
                        Text("다음")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 52)
                    .background(canProceed ? .primaryNormal : Color.gray.opacity(0.3))
                    .cornerRadius(12)
                }
                .disabled(!canProceed)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom,12)

    
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .background(.gray750)
    }
    
    private func toggleAllAgree() {

        let newValue = !allAgree
        allAgree = newValue
               
        ageAgree = newValue
        serviceAgree = newValue
        privacyAgree = newValue

    }
    
    private func updateAllAgreeStatus() {
        let oldAllAgree = allAgree
        allAgree = ageAgree && serviceAgree && privacyAgree
    }
}

