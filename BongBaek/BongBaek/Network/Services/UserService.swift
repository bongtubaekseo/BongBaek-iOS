//
//  UserService.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//

import Foundation
import Combine

class UserService : MyPageServiceProtocol {
    private let networkService : NetworkService<MyPageTarget>
    
    init(networkService: NetworkService<MyPageTarget>){
        self.networkService = networkService
    }
    
    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        return networkService.request(
            .getProfile,
            responseType: ProfileResponse.self
        )
    }
    
    func updateProfile(profileData: UpdateProfileData) -> AnyPublisher<UpdateProfileResponse, Error> {
        return networkService.request(
            .updateProfile(profileData: profileData),
            responseType: UpdateProfileResponse.self
        )
    }
}
