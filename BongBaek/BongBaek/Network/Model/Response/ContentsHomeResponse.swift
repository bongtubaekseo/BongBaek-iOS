//
//  ContentsHomeResponse.swift
//  BongBaek
//
//  Created by 임재현 on 11/28/25.
//

import Foundation

typealias ContentsHomeResponse = BaseResponseV2<ContentsHomeResponseData>

struct ContentsHomeResponseData: Codable {
    let contents: [ContentHomeItem]
}

struct ContentHomeItem: Codable {
    let contentId: String
    let contentTitle: String
    let contentCategory: String
    let thumbnailUrl: String
}
