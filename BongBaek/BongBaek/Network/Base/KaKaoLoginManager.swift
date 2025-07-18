//
//  KaKaoLoginManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import KakaoSDKUser

class KakaoLoginManager {
    static let shared = KakaoLoginManager()
    private init() {}
    
    func login() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let accessToken = oauthToken?.accessToken {
                        continuation.resume(returning: accessToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let accessToken = oauthToken?.accessToken {
                        continuation.resume(returning: accessToken)
                    }
                }
            }
        }
    }
}
