//
//  AppConfig.swift
//  BongBaek
//
//  Created by 임재현 on 7/11/25.
//

import SwiftUI

struct AppConfig {
    static let shared = AppConfig()
    
    private init() {}
    
     var baseURL: String = {
        guard let url = Bundle.main.infoDictionary?["BASE_URL_RELEASE"] as? String else {
            fatalError("API_BASE_URL is missing in Info.plist")
        }
        return url
    }()
    
    var baseURLForTest: String = {
       guard let url = Bundle.main.infoDictionary?["BASE_URL_TEST"] as? String else {
           fatalError("API_BASE_URL is missing in Info.plist")
       }
       return url
   }()
    
     var apiVersion: String = "/v1"
    

    
     var kakaoAppKey: String = {
        guard let key = Bundle.main.infoDictionary?["KAKAO_NATIVE_APPKEY"] as? String else {
            fatalError("Kakao App Key is missing in Info.plist")
        }
        return key
    }()
    
    
    var kakaoAPIKey: String {
        return UserDefaults.standard.apiKey
    }
    

    var networkTimeout: TimeInterval { return 30.0 }
    var maxRetryCount: Int { return 3 }
    
    
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
