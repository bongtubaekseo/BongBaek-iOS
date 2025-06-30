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
    @State private var locationAgree = false
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
                        .titleSemiBold20()
                        .foregroundStyle(.black)
                    Text("꼭 필요한 권한만 받아요.")
                        .titleSemiBold20()
                        .foregroundStyle(.black)
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
                        
                        CheckButton(
                            title: "위치 정보 액세스 권한",
                            isRequired: false,
                            isChecked: $locationAgree,
                            onTap: {
                                print("위치 정보 액세스 권한 버튼 클릭됨")
                                print("클릭 후 locationAgree: \(locationAgree)")
                                updateAllAgreeStatus()
                            }
                        )
                    }
                }
                .padding(.top, 12)

                Spacer()
                
                Button("허용하고 계속하기") {
                    print("허용하고 계속하기 버튼 클릭됨")
                    print("canProceed: \(canProceed)")
                    onComplete()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canProceed ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
    
    private func toggleAllAgree() {

        let newValue = !allAgree
        allAgree = newValue
               
        ageAgree = newValue
        serviceAgree = newValue
        privacyAgree = newValue
        locationAgree = newValue

    }
    
    private func updateAllAgreeStatus() {
        let oldAllAgree = allAgree
        allAgree = ageAgree && serviceAgree && privacyAgree && locationAgree
    }
}

