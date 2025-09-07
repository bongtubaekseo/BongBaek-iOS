//
//  MyPageServiceProtocol.swift
//  BongBaek
//
//  Created by hyunwoo on 9/4/25.
//
import Moya
import Combine

protocol MyPageServiceProtocol {
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
    func updateProfile(profileData : UpdateProfileData) -> AnyPublisher<UpdateProfileResponse, Error>
}
