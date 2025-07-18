//
//  GlobalStepManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/3/25.
//

import SwiftUI

class GlobalStepManager: ObservableObject {
    @Published var currentStep: Int = 1
    let totalSteps: Int = 4
    
    func nextStep() {
        if currentStep < totalSteps {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }
    
    func resetToFirstStep() {
        currentStep = 1
    }
    
    var isLastStep: Bool {
        currentStep == totalSteps
    }
}

