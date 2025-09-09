//
//  DateFormat+.swift
//  BongBaek
//
//  Created by hyunwoo on 9/9/25.
//

import SwiftUI


extension String {
    func DateFormat() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        
        return self
    }
}
