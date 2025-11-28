//
//  ContentsService.swift
//  BongBaek
//
//  Created by 임재현 on 11/28/25.
//

import Foundation
import Combine

class ContentsService: ContentsServiceProtocol {

    private let networkService: NetworkService<ContentsTarget>
    
    init(networkService: NetworkService<ContentsTarget>) {
        self.networkService = networkService
    }
    
    func getHomeContents() -> AnyPublisher<ContentsHomeResponse, Error> {
        return networkService.request(
            .getContentsHome,
            responseType: ContentsHomeResponse.self
        )
    }
}
