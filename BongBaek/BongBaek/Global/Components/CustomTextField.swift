//
//  CustomTextField.swift
//  BongBaek
//
//  Created by 임재현 on 6/29/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let validationRule: ValidationRule?
    let isSecure: Bool
    
    @State private var validationState: ValidationState = .normal
    @State private var validationMessage: String = ""
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    
    init(title: String,
         icon: String,
         placeholder: String,
         text: Binding<String>,
         validationRule: ValidationRule? = nil,
         isSecure: Bool = false) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.validationRule = validationRule
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
  
            HStack(spacing: 8) {
                Image("icon_person_16")
                    .resizable()
                    .frame(width: 16,height: 16)
                
                Text(title)
                    .bodyMedium16()
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                    } else {
                        TextField(placeholder, text: $text)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
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
                .padding(.vertical, 12)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(lineColor)
                    .animation(.easeInOut(duration: 0.2), value: validationState)
            }
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .font(.system(size: 12))
                    .foregroundColor(validationState.color)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2), value: validationMessage)
            }
        }
        .onChange(of: text) { _, newValue in
            validateInput(newValue)
        }
    }
    
    private var lineColor: Color {
        if isFocused {
            return validationState == .invalid ? .red : .blue
        }
        return validationState.color
    }
    
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

enum ValidationState {
    case normal
    case valid
    case invalid
    
    var color: Color {
        switch self {
        case .normal:
            return .gray
        case .valid:
            return .blue
        case .invalid:
            return .red
        }
    }
}

struct ValidationRule {
    let minLength: Int?
    let maxLength: Int?
    let customRule: ((String) -> Bool)?
    let customMessage: String?
    
    init(minLength: Int? = nil,
         maxLength: Int? = nil,
         customRule: ((String) -> Bool)? = nil,
         customMessage: String? = nil) {
        self.minLength = minLength
        self.maxLength = maxLength
        self.customRule = customRule
        self.customMessage = customMessage
    }
    
    func validate(_ text: String) -> (isValid: Bool, message: String) {
        if text.isEmpty {
            if let minLength = minLength, let maxLength = maxLength {
                return (false, "\(minLength)자에서 \(maxLength)자 내외 입력해야 합니다")
            } else if let minLength = minLength {
                return (false, "\(minLength)자 이상 입력해야 합니다")
            } else if let maxLength = maxLength {
                return (false, "\(maxLength)자 이하로 입력해야 합니다")
            }
            return (false, "입력이 필요합니다")
        }
        
        if let minLength = minLength, text.count < minLength {
            if let maxLength = maxLength {
                return (false, "\(minLength)자에서 \(maxLength)자 내외 입력해야 합니다")
            }
            return (false, "\(minLength)자 이상 입력해야 합니다")
        }
        
        if let maxLength = maxLength, text.count > maxLength {
            if let minLength = minLength {
                return (false, "\(minLength)자에서 \(maxLength)자 내외 입력해야 합니다")
            }
            return (false, "\(maxLength)자 이하로 입력해야 합니다")
        }
        
        if let customRule = customRule {
            let isValid = customRule(text)
            let message = customMessage ?? (isValid ? "올바른 형식입니다" : "형식이 올바르지 않습니다")
            return (isValid, message)
        }
        
        return (true, "올바른 형식입니다")
    }
}
