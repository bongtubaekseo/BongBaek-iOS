//
//  BongBaekApp.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//

import SwiftUI
import Moya
import KakaoMapsSDK

@main
struct BongBaekApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {

            EventLocationView()

        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
       if let APIKEY = Bundle.main.infoDictionary?["KAKAONATIVEAPPKEY"] as? String {
           SDKInitializer.InitSDK(appKey: APIKEY)
       } else {
           fatalError("Kakao App Key is missing in Info.plist")
       }

        return true
    }
}
