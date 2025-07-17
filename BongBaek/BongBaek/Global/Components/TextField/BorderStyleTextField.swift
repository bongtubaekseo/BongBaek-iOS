//
//  BorderStyleTextField.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

struct BorderTextField: View {
    let placeholder: String
    @Binding var text: String
    let validationRule: ValidationRule?
    let isSecure: Bool
    
    @State private var validationState: ValidationState = .normal
    @State private var validationMessage: String = ""
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    
    init(
        placeholder: String,
        text: Binding<String>,
        validationRule: ValidationRule? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.validationRule = validationRule
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .tint(.white)
                } else {
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 16))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        
                        TextField("", text: $text)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                            .foregroundColor(.white)
                            .tint(.white)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    if !text.isEmpty && isFocused {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                text = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    if isSecure {
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
//                    if !text.isEmpty && validationRule != nil {
//                        Image(systemName: validationState == .valid ? "checkmark" : "exclamationmark")
//                            .foregroundStyle(validationState == .valid ? .green : .red)
//                            .font(.system(size: 16, weight: .semibold))
//                            .transition(.scale.combined(with: .opacity))
//                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(.gray800)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: validationState)
            
            // 유효성 검사 메시지
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .captionRegular12()
                    .foregroundColor(validationState.color)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2), value: validationMessage)
            }
        }
        .onChange(of: text) { _, newValue in
            validateInput(newValue)
        }
    }
    
    private var backgroundColor: Color {
        if isFocused || !text.isEmpty {
            switch validationState {
            case .invalid:
                return .secondaryRed
            case .valid:
                return .primaryNormal
            default:
                return .gray800
            }
        }
        return .gray800
    }
    
    private var borderColor: Color {
        if isFocused {
            return validationState == .invalid ? .secondaryRed : .primaryNormal
        }
        if !text.isEmpty {
            switch validationState {
            case .valid:
                return .primaryNormal
            case .invalid:
                return .secondaryRed
            default:
                return .lineNormal
            }
        }
        return .lineNormal
    }
    
    private var borderWidth: CGFloat {
        if isFocused || (!text.isEmpty && validationState != .normal) {
            return 2
        }
        return 1
    }
    
    // MARK: - 유효성 검사 함수
    private func validateInput(_ input: String) {
        guard let rule = validationRule else {
            validationState = .normal
            validationMessage = ""
            return
        }
        
        let validation = rule.validate(input)
        
        withAnimation(.easeInOut(duration: 0.2)) {
            if input.isEmpty {
                validationState = .normal
                validationMessage = ""
            } else {
                validationState = validation.isValid ? .valid : .invalid
                validationMessage = validation.message
            }
        }
    }
}
