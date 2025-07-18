//
//  KakaoSearchResponse.swift
//  BongBaek
//
//  Created by 임재현 on 7/9/25.
//

import SwiftUI

struct KakaoSearchResponse: Codable {
    let documents: [KLDocument]
}

struct KLDocument: Codable, Identifiable, Hashable {
    let id = UUID()
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String
    
    var displayText: String {
        return "\(placeName) - \(addressName)"
    }
    
    var primaryAddress: String {
        return roadAddressName.isEmpty ? addressName : roadAddressName
    }
    
    enum CodingKeys: String, CodingKey {
        case x, y, distance
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
    }
}


