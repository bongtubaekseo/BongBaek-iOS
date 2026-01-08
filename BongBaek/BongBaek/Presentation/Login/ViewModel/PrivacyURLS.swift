//
//  PrivacyURLS.swift
//  BongBaek
//
//  Created by 임재현 on 9/26/25.
//

import Foundation
import UIKit

enum PrivacyUrls: String {
    // 개인정보처리방침
    case personalInformationURL = "https://www.notion.so/264f06bb0d3480d0b1eafa217b306105"
    // 이용약관
    case termsOfUseURL = "https://www.notion.so/bongtubaekseo/264f06bb0d348036b260f175a236ec7c"
}



protocol URLOpenProtocol {
    func openLink(url: URL)
}

struct URLOpener: URLOpenProtocol {
    func openLink(url: URL) {
        UIApplication.shared.open(url)
    }
}

class MockURLOpener: URLOpenProtocol {
    
    var openLinkCalled: Bool = false
    var lastOpenURL: URL?
    
     func openLink(url: URL) {
        self.openLinkCalled = true
        self.lastOpenURL = url
    }
    
     func reset() {
        self.openLinkCalled = false
        self.lastOpenURL = nil

     }
}
