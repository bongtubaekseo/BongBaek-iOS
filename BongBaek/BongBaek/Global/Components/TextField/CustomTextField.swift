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
    let isRequired: Bool
    
    @State private var validationState: ValidationState = .normal
    @State private var validationMessage: String = ""
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    let isReadOnly: Bool
    let onTap: (() -> Void)?
    
    init(title: String,
         icon: String,
         placeholder: String,
         text: Binding<String>,
         validationRule: ValidationRule? = nil,
         isSecure: Bool = false,
         isReadOnly: Bool = false,
         isRequired: Bool = false,
         onTap: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.validationRule = validationRule
        self.isSecure = isSecure
        self.isReadOnly = isReadOnly
        self.isRequired = isRequired
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
  
            HStack(spacing: 8) {
                Image("icon_person_16")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16,height: 16)
                    .foregroundStyle(.white)
                
                HStack(spacing: 2) {  
                    Text(title)
                        .bodyMedium16()
                        .foregroundColor(.white)
                    
                    if isRequired {
                        
                        VStack {
                            Text("*")
                                .bodyMedium16()
                                .foregroundColor(.blue)
                                .padding(.top, 2)
                                .padding(.leading, 1)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                            .disabled(isReadOnly)
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
                                .disabled(isReadOnly)
                                .foregroundColor(.white)
                                .tint(.white)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        if !text.isEmpty && !isReadOnly && isFocused {
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
                        
                        if isReadOnly {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        if isSecure && !isReadOnly {
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
                .padding(.vertical, 12)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isReadOnly {
                        onTap?()
                    }
                }
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
            if !isReadOnly { 
                validateInput(newValue)
            }
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
