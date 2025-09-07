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
    let keyboardType: UIKeyboardType 
    
    @State private var validationState: ValidationState = .normal
    @State private var validationMessage: String = ""
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    let isReadOnly: Bool
    let onTap: (() -> Void)?
    
    // 숫자 포맷팅을 위한 상태
    @State private var displayText: String = ""
    
    init(title: String,
         icon: String,
         placeholder: String,
         text: Binding<String>,
         validationRule: ValidationRule? = nil,
         isSecure: Bool = false,
         isReadOnly: Bool = false,
         isRequired: Bool = false,
         keyboardType: UIKeyboardType = .default, // 새로 추가
         onTap: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.validationRule = validationRule
        self.isSecure = isSecure
        self.isReadOnly = isReadOnly
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
  
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .frame(width: 16,height: 16)
                
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
                            .keyboardType(keyboardType) // 키보드 타입 적용
                    } else {
                        ZStack(alignment: .leading) {
                            if displayText.isEmpty {
                                Text(placeholder)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            
                            TextField("", text: $displayText)
                                .font(.system(size: 16))
                                .textFieldStyle(PlainTextFieldStyle())
                                .focused($isFocused)
                                .disabled(isReadOnly)
                                .foregroundColor(.white)
                                .tint(.white)
                                .keyboardType(keyboardType) // 키보드 타입 적용
                                .onChange(of: displayText) { _, newValue in
                                    handleTextChange(newValue)
                                }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        if !displayText.isEmpty && !isReadOnly && isFocused {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    displayText = ""
                                    text = ""
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            .transition(.scale.combined(with: .opacity))
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
        .onAppear {
            // 초기값 설정
            if !text.isEmpty && (keyboardType == .numberPad || keyboardType == .decimalPad) {
                displayText = formatNumber(text)
            } else {
                displayText = text
            }
        }
        .onChange(of: text) { _, newValue in
            if !isReadOnly && (keyboardType == .numberPad || keyboardType == .decimalPad) {
                displayText = formatNumber(newValue)
            } else {
                if isReadOnly && newValue.contains(".") {
                    displayText = formatDate(newValue)
                } else {
                    displayText = newValue
                }
            }
            validateInput(newValue)
        }
    }
    
    // 숫자 포맷팅 함수
    private func formatNumber(_ input: String) -> String {
        // 숫자만 추출
        let numbersOnly = input.filter { $0.isNumber }
        
        guard !numbersOnly.isEmpty else { return "" }
        
        // 숫자를 Int로 변환 후 천 단위 콤마 추가
        if let number = Int(numbersOnly) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: number)) ?? numbersOnly
        }
        
        return numbersOnly
    }
    
    private func formatDate(_ input: String) -> String {
        if input.contains(".") {
            let components = input.split(separator: ".")
            
            guard components.count == 3 else { return input }
            
            let year = String(components[0])
            let month = String(components[1])
            let day = String(components[2])
            
            return "\(year)년 \(month)월 \(day)일"
        }
        
        return input
    }
    
    // 텍스트 변경 처리
    private func handleTextChange(_ newValue: String) {
        if keyboardType == .numberPad || keyboardType == .decimalPad {
            // 숫자만 추출
            let numbersOnly = newValue.filter { $0.isNumber }
            
            // 원본 text에는 숫자만 저장
            text = numbersOnly
            
            // 화면에는 포맷된 텍스트 표시
            displayText = formatNumber(numbersOnly)
            
            // 유효성 검사는 숫자만으로
            validateInput(numbersOnly)
        } else {
            // 일반 텍스트는 그대로 처리
            text = newValue
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
            return .gray500
        case .valid:
            return .primaryNormal
        case .invalid:
            return .secondaryRed
        }
    }
}


struct ValidationRule {
    let minLength: Int?
    let maxLength: Int?
    let regex: String?
    let customRule: ((String) -> Bool)?
    let customMessage: String?
    
    init(minLength: Int? = nil,
         maxLength: Int? = nil,
         regex: String? = nil,
         customRule: ((String) -> Bool)? = nil,
         customMessage: String? = nil) {
        self.minLength = minLength
        self.maxLength = maxLength
        self.regex = regex
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
        
        if let regex = regex {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if !predicate.evaluate(with: text) {
                return (false, customMessage ?? "올바른 형식이 아닙니다")
            }
        }
        
        if let customRule = customRule {
            let isValid = customRule(text)
            let message = customMessage ?? (isValid ? "올바른 형식입니다" : "형식이 올바르지 않습니다")
            return (isValid, message)
        }
        
        return (true, "")
    }
}
