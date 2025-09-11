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
    
    @Binding var isValid: Bool
    
    init(
        placeholder: String,
        text: Binding<String>,
        isValid: Binding<Bool> = .constant(true),
        validationRule: ValidationRule? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.validationRule = validationRule
        self.isSecure = isSecure
        self._isValid = isValid
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
                HStack(spacing: 4) {
                    Image(validationState == .invalid ? "icon_caution" : "")
                        .font(.system(size: 12))
                        .foregroundColor(validationState.color)
                    
                    Text(validationMessage)
                        .font(.system(size: 12))
                        .foregroundColor(validationState.color)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.2), value: validationMessage)
            }
        }
        .onChange(of: text) { _, newValue in
            validateInput(newValue)
        }
        .onChange(of: isFocused) { _, newValue in
             validateInput(text)
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
    
    
    private var borderWidth: CGFloat {
        if isFocused || (!text.isEmpty && validationState != .normal) {
            return 2
        }
        return 1
    }
    
    // MARK: - 유효성 검사 함수
    private var borderColor: Color {
        return validationState.color
    }
    
    private func validateInput(_ input: String) {
        guard let rule = validationRule else {
            isValid = !input.isEmpty
            
            if isFocused {
                validationState = .focused
            } else {
                validationState = input.isEmpty ? .normal : .completed
            }
            validationMessage = ""
            return
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            if input.isEmpty {
                isValid = false
                validationState = isFocused ? .focused : .normal
                validationMessage = ""
            } else {
                if let regex = rule.regex {
                    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                    if !predicate.evaluate(with: input) {
                        isValid = false
                        validationState = .invalid
                        validationMessage = rule.customMessage ?? "특수문자는 기입할 수 없어요"
                        return
                    }
                }
                
                let validation = rule.validate(input)
                isValid = validation.isValid
                
                if validation.isValid {
                    validationState = isFocused ? .valid : .completed
                } else {
                    validationState = .invalid
                }
                validationMessage = validation.message
            }
        }
    }
}
