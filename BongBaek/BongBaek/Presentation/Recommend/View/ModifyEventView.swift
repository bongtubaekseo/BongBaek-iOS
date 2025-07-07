//
//  ModifyEventView.swift
//  BongBaek
//
//  Created by 임재현 on 7/6/25.
//

import SwiftUI

struct ModifyEventView: View {
    @State var nickname: String = ""
    @State private var selectedAttend: TextDropdownItem?
    @State private var showDatePicker = false
    @State var selectedDate: String = ""
    
    let eventItems = [
        TextDropdownItem(title: "참석"),
        TextDropdownItem(title: "미참석"),

    ]
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Button(action: {
                        
                    }) {
                        Text("취소")
                            .bodyRegular16()
                            .foregroundStyle(.gray200)
               
                    }
                    .frame(width: 44, height: 44)
                    .padding(.leading, -8)
                    
                    Spacer()
                    
                    Text("경조사 수정하기")
                        .titleSemiBold18()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 16)
                .background(.gray900)
                
                VStack {
                    VStack {
                        CustomTextField(
                            title: "닉네임",
                            icon: "person.circle",
                            placeholder: "닉네임을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            )
                        )
                        
                        CustomTextField(
                            title: "별명",
                            icon: "icon_nickname_16",
                            placeholder: "닉네임을 입력하세요",
                            text: $nickname,
                            validationRule: ValidationRule(
                                minLength: 2,
                                maxLength: 10
                            )
                        )
                        .padding(.top, 32)
                    }
                    .padding(.horizontal, 20)

                    DropdownView()
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            CustomTextField(
                                title: "경조사",
                                icon: "icon_event_16",
                                placeholder: "금액을 입력하세요",
                                text: $nickname,
                                validationRule: ValidationRule(
                                    minLength: 1,
                                    maxLength: 10
                                )
                            )
                            
                            Text("원")
                                .bodyRegular16()
                                .foregroundColor(.white)
                        }
                        
                        CustomDropdown(
                            title: "참석여부",
                            icon: "icon_come_16",
                            placeholder: "경조사를 선택하세요",
                            items: eventItems,
                            selectedItem: $selectedAttend
                        )
                        .padding(.top, 16)
                        
                        CustomTextField(
                            title: "날짜",
                            icon: "icon_calendar_16",
                            placeholder: "생년월일을 입력하세요",
                            text: $selectedDate,
                            isReadOnly: true) {
                                print("생년월일 필드 터치됨")
                              
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDatePicker = true
                                }
                            }
                            .padding(.top, 16)
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    EventMapView()
                        .padding(.top, 16)
                    
                    
                    Button {

                    } label: {
                        Text("다음 단계로")
                            .titleSemiBold18()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.primaryNormal)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                }
            }
        }
        .background(Color.background)
    }
}

#Preview {
    ModifyEventView()
}


