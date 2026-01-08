//
//  ContentsServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 11/28/25.
//

import Foundation
import Combine

protocol ContentsServiceProtocol {
    func getHomeContents() async throws -> ContentsHomeResponse
    func getMoreContents(page: Int, category: String?) async throws -> MoreContentsResponse
    func getMoreContentsDetail(contentId: String) async throws -> MoreContentsDetailResponse
}
