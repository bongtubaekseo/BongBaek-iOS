//
//  AmountRecommendationRequest.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import Foundation

struct AmountRecommendationRequest: Codable {
    let category: String
    let relationship: String
    let attended: Bool
    let locationInfo: RecommendationLocationInfo
    let highAccuracy: HighAccuracyInfo
}

struct RecommendationLocationInfo: Codable {
    let location: String
}
