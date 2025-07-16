//
//  KeyChainManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/14/25.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    private let serviceName = Bundle.main.bundleIdentifier ?? "com.BongBaek.keychain"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    private init() {}
    
    
    /// 액세스 토큰과 리프레시 토큰을 동시에 저장
    func saveTokens(access: String, refresh: String) -> Result<Void, AuthError> {
        switch save(key: accessTokenKey, value: access) {
        case .success:
            switch save(key: refreshTokenKey, value: refresh) {
            case .success:
                return .success(())
            case .failure(let error):
                // 액세스 토큰 저장 성공했지만 리프레시 토큰 실패시 롤백
                delete(key: accessTokenKey)
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 액세스 토큰 업데이트
    @discardableResult
    func updateAccessToken(_ token: String) -> Result<Void, AuthError> {
        return save(key: accessTokenKey, value: token)
    }
    
    /// 리프레시 토큰 업데이트
    @discardableResult
    func updateRefreshToken(_ token: String) -> Result<Void, AuthError> {
        return save(key: refreshTokenKey, value: token)
    }
    
    /// 액세스 토큰 조회
    func getAccessToken() -> Result<String, AuthError> {
        return load(key: accessTokenKey)
    }
    
    /// 리프레시 토큰 조회
    func getRefreshToken() -> Result<String, AuthError> {
        return load(key: refreshTokenKey)
    }
    
    /// 모든 토큰 삭제
    @discardableResult
    func clearTokens() -> Result<Void, AuthError> {
        let accessResult = delete(key: accessTokenKey)
        let refreshResult = delete(key: refreshTokenKey)
        
        // 둘 중 하나라도 실패하면 실패로 처리
        switch (accessResult, refreshResult) {
        case (.success, .success):
            return .success(())
        case (.failure(let error), _), (_, .failure(let error)):
            return .failure(error)
        }
    }
    
    /// 토큰 존재 여부 확인
    func hasTokens() -> Bool {
        switch (getAccessToken(), getRefreshToken()) {
        case (.success, .success):
            return true
        default:
            return false
        }
    }

    /// 액세스 토큰 편의 프로퍼티
    var accessToken: String? {
        get {
            switch getAccessToken() {
            case .success(let token): return token
            case .failure: return nil
            }
        }
        set {
            if let token = newValue {
                updateAccessToken(token)
            } else {
                delete(key: accessTokenKey)
            }
        }
    }
    
    /// 리프레시 토큰 편의 프로퍼티
    var refreshToken: String? {
        get {
            switch getRefreshToken() {
            case .success(let token): return token
            case .failure: return nil
            }
        }
        set {
            if let token = newValue {
                updateRefreshToken(token)
            } else {
                delete(key: refreshTokenKey)
            }
        }
    }
    
    
    /// 키체인에 값 저장
    private func save(key: String, value: String) -> Result<Void, AuthError> {
        guard let data = value.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status: OSStatus
        
        // 기존 아이템이 있는지 확인
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            // 업데이트
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            // 새로 추가
            var newItem = query
            newItem[kSecValueData as String] = data
            status = SecItemAdd(newItem as CFDictionary, nil)
        }
        
        return status == errSecSuccess ? .success(()) : .failure(.keychainError)
    }
    
    /// 키체인에서 값 로드
    private func load(key: String) -> Result<String, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            return status == errSecItemNotFound ? .failure(.tokenNotFound) : .failure(.keychainError)
        }
        
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return .failure(.invalidData)
        }
        
        return .success(value)
    }
    
    /// 키체인에서 값 삭제
    private func delete(key: String) -> Result<Void, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        // 성공이거나 아이템이 없었던 경우 모두 성공으로 처리
        return (status == errSecSuccess || status == errSecItemNotFound)
            ? .success(())
            : .failure(.keychainError)
    }
}


#if DEBUG
extension KeychainManager {
    /// 디버깅용 토큰 정보 출력
    func printTokenStatus() {
        print("=== Token Status ===")
        print("Access Token: \(accessToken != nil ? "존재" : "없음")")
        print("Refresh Token: \(refreshToken != nil ? "존재" : "없음")")
        print("Has Both Tokens: \(hasTokens())")
        print("==================")
    }
}
#endif
