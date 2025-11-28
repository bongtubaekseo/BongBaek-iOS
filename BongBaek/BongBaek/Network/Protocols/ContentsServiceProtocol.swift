//
//  ContentsServiceProtocol.swift
//  BongBaek
//
//  Created by 임재현 on 11/28/25.
//

import Foundation
import Combine

protocol ContentsServiceProtocol {
    func getHomeContents() -> AnyPublisher<ContentsHomeResponse, Error>
}
