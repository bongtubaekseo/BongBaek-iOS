//
//  RemoteConfigManager.swift
//  BongBaek
//
//  Created by 임재현 on 9/2/25.
//

import Foundation
import FirebaseRemoteConfig


class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private let remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 
        remoteConfig.configSettings = settings
    }
    
    func checkForceUpdate() async -> (isRequired: Bool, message: String, updateType: UpdateType) {
        do {
            try await remoteConfig.fetch()
            try await remoteConfig.activate()
            
            // 1. 긴급 업데이트 체크 (앱 문제로 인한 전체 강제 업데이트)
            let isEmergencyUpdate = remoteConfig["isNeedsUpdate_iOS"].boolValue
            
            print("긴급 업데이트가 필요한가? \(isEmergencyUpdate)")
            
            // 2. 버전 기반 업데이트 체크
            let minVersion = remoteConfig["minimum_version_iOS"].stringValue
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let isVersionUpdateRequired = compareVersions(current: currentVersion, minimum: minVersion)
            
            print("최소 설치 되어야 하는 버전\(minVersion)")
            print("현재 기기에 설치되어있는 앱 버전\(currentVersion)")
           
            let updateMessage: String
            let updateType: UpdateType
            
            if isEmergencyUpdate {
                updateMessage = remoteConfig["emergency_update_message_iOS"].stringValue.isEmpty ?
                    "앱에 중요한 업데이트가 있습니다. 반드시 업데이트해주세요." :
                    remoteConfig["emergency_update_message_iOS"].stringValue
                updateType = .emergency
            } else if isVersionUpdateRequired {
                updateMessage = remoteConfig["update_message_iOS"].stringValue.isEmpty ?
                    "새 버전이 출시되었습니다. 업데이트해주세요." :
                    remoteConfig["update_message_iOS"].stringValue
                updateType = .version
            } else {
                updateMessage = ""
                updateType = .none
            }
            
            let isUpdateRequired = isEmergencyUpdate || isVersionUpdateRequired
            
            print("Emergency: \(isEmergencyUpdate), Version Required: \(isVersionUpdateRequired)")
            print("MinVersion: \(minVersion), CurrentVersion: \(currentVersion)")
            
            return (isUpdateRequired, updateMessage, updateType)
        } catch {
            print("RemoteConfig Error: \(error)")
            return (false, "", .none)
        }
    }

    enum UpdateType {
        case none
        case emergency    // 긴급 업데이트 (앱 문제)
        case version      // 버전 업데이트 (필수/선택)
    }
    
    private func compareVersions(current: String, minimum: String) -> Bool {
        guard !minimum.isEmpty else { return false }
        return current.compare(minimum, options: .numeric) == .orderedAscending
    }
}
