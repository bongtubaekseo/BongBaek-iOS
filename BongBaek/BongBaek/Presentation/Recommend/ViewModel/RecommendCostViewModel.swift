// RecommendCostViewModel.swift
import SwiftUI

class RecommendCostViewModel: ObservableObject {
    @Published var selectedAmount: Int = 100000
    @Published var minAmount: Int = 0
    @Published var maxAmount: Int = 1000000
    @Published var customAmount: String = ""
    
    let recommendedAmounts = [100000, 150000, 200000]
    
    var sliderProgress: Double {
        Double(selectedAmount - minAmount) / Double(maxAmount - minAmount)
    }
    
    func updateFromServerData(recommended: Int, min: Int, max: Int) {
        selectedAmount = recommended
        minAmount = min
        maxAmount = max
    }
    
    var formattedSelectedAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: selectedAmount)) ?? "0"
    }
    
    var formattedMinAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: minAmount)) ?? "0"
    }
    
    var formattedMaxAmount: String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: maxAmount)) ?? "0"
    }
    
    func updateAmount(to amount: Int) {
        selectedAmount = amount
    }
    
    func updateSliderAmount(to value: Double) {
        selectedAmount = Int(value)
    }
}
