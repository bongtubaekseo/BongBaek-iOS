//
//  BongBaekApp.swift
//  BongBaek
//
//  Created by 임재현 on 6/28/25.
//

import SwiftUI
import Moya
import KakaoMapsSDK
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase

@main
struct BongBaekApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showLoginView = false
    @StateObject private var router = NavigationRouter()
    @StateObject private var eventManager = EventCreationManager()

    init() {
        let API_KEY = AppConfig.shared.kakaoAppKey
        KakaoSDK.initSDK(appKey: API_KEY)
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL(perform:{ url in
                    if(AuthApi.isKakaoTalkLoginUrl(url)){
                        _ = AuthController.handleOpenUrl(url:url)
                    }
                })
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
       if let APIKEY = Bundle.main.infoDictionary?["KAKAO_NATIVE_APPKEY"] as? String {
           SDKInitializer.InitSDK(appKey: APIKEY)
       } else {
           fatalError("Kakao App Key is missing in Info.plist")
       }

        return true
    }
}
