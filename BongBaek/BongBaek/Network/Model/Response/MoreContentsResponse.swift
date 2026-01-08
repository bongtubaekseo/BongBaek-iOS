//
//  MoreContentsResponse.swift
//  BongBaek
//
//  Created by 임재현 on 12/4/25.
//

import Foundation

typealias MoreContentsResponse = BaseResponseV2<MoreContentsResponseData>

struct MoreContentsResponseData: Codable {
    let contents: [MoreContentItem]
    let currentPage: Int
    let totalPages: Int
    let totalElements: Int
    let isLast: Bool
}

struct MoreContentItem: Codable {
    let contentId: String
    let contentTitle: String
    let contentCategory: String
    let thumbnailUrl: String
    let createdAt: String
}
