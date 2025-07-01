//
//  ProfileSettingView.swift
//  BongBaek
//
//  Created by 임재현 on 7/1/25.
//

import SwiftUI

struct ProfileSettingView: View {
    @State var nickname:String = ""
    var body: some View {
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
        .padding(.horizontal,20)
    }
}

#Preview {
    ProfileSettingView()
}
