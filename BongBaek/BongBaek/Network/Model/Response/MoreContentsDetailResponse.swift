//
//  MoreContentsDetailResponse.swift
//  BongBaek
//
//  Created by 임재현 on 12/5/25.
//

import Foundation

typealias MoreContentsDetailResponse = BaseResponseV2<MoreContentsDetailResponseData>

struct MoreContentsDetailResponseData: Codable {
    let contents: [MoreContentItem]
}
