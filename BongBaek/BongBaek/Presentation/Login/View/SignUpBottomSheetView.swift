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
    
    @Environment(\.openURL) var openURL
    
    private var canProceed: Bool {
        ageAgree && serviceAgree && privacyAgree
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(alignment: .leading){
                Text("앱 사용을 위해 권한을 허용해주세요.")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
                Text("서비스 이용에 필수적인 약관들이에요.")
                    .titleSemiBold18()
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top,40.adjustedH)
            .padding(.leading,20)
            
            VStack(alignment: .leading, spacing: 16.adjustedH) {
                
                CheckButton(
                    title: "서비스 이용 약관 전체 동의",
                    isRequired: nil,
                    isChecked: $allAgree,
                    manualToggle: true,
                    isHighlighted: true,
                    onTap: {
                        print("전체 동의 버튼 클릭됨")
                        print("전체 동의 클릭 전 상태: allAgree=\(allAgree)")
                        toggleAllAgree()
                    }
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 16.adjustedH) {
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
                            openURL(URL(string: "https://www.notion.so/264f06bb0d3480aa8badeba07a68b944")!)
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
                            openURL(URL(string: "https://www.notion.so/264f06bb0d3480d0b1eafa217b306105")!)
                        }
                    )
                }
            }
            .padding(.top,30.adjustedH)
            .padding(.horizontal,20)
            
            Spacer()
            
            Button(action: {
                print("허용하고 계속하기 버튼 클릭됨")
                print("canProceed: \(canProceed)")
                onComplete()
            }) {
                HStack {
                    Spacer()
                    Text("다음")
                        .titleSemiBold18()
                        .foregroundColor(canProceed ? .white : .gray500)
                    Spacer()
                }
                .frame(height: 55.adjustedH)
                .background(canProceed ? .primaryNormal : Color.primaryBg)
                .cornerRadius(12)
            }
            .disabled(!canProceed)
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal,20)
            .padding(.bottom,60.adjustedH)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        _ = allAgree
        allAgree = ageAgree && serviceAgree && privacyAgree
    }
}

