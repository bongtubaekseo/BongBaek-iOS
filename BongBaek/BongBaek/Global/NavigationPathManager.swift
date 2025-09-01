//
//  NavigationPathManager.swift
//  BongBaek
//
//  Created by 임재현 on 7/12/25.
//

import SwiftUI

enum RecommendRoute: Hashable {
    case recommendView
    case eventInformationView
    case eventDateView
    case eventLocationView
    case recommendLoadingView
    case recommendLottie
    case recommendCostView
    case recommendSuccessView
    case modifyEventView(mode: ModifyMode, eventDetailData: EventDetailData?)
    case modifyEventView2(mode: ModifyMode, eventDetailData: EventDetailData?)
    case fullScheduleView
    case allRecordView(eventId: String)
    case allRecordView2(eventId: String)
    case recommendStartView
    case emptyScheduleView
    case emptyCardView
    case createEventView
    case createEventViewAfterEvent
    case accountDeletionView
    case accountDeletionConfirmView
    case MyPageView
    case ModifyView
    
    var displayName: String {
        switch self {
        case .recommendView: return "RecommendView"
        case .eventInformationView: return "EventInformationView"
        case .eventDateView: return "EventDateView"
        case .eventLocationView: return "EventLocationView"
        case .recommendLoadingView: return "RecommendLoadingView"
        case .recommendLottie: return "RecommendLottie"
        case .recommendCostView: return "RecommendCostView"
        case .recommendSuccessView: return "RecommendSuccessView"
        case .modifyEventView: return "modifyEventView"
        case .fullScheduleView: return "fullScheduleView"
        case .allRecordView: return "allRecordView"
        case .recommendStartView: return "recommendStartView"
        case .emptyScheduleView: return "emptyScheduleView"
        case .emptyCardView: return "emptyCardView"
            
        case .createEventView: return "createEventView"
//        case .largeMapView:  return "largeMapView"
            
        case .allRecordView2: return "allRecordView2"
        case .modifyEventView2: return "modifyEventView2"
        case .createEventViewAfterEvent: return "createEventViewAfterEvent"
        case .accountDeletionConfirmView: return "acountDeletionConfirmView"
        case .accountDeletionView: return "accountDeletionView"
        case .ModifyView : return "ModifyView"
        case .MyPageView : return "MyPageView"
            
        }
    }
}


final class NavigationRouter: ObservableObject {
    
    @Published var path = NavigationPath() {
        didSet {
            print("NavigationPath 변경됨: \(path.count)개 화면")
        }
    }
    
    /// 다음 화면으로 이동
    func push(to route: RecommendRoute) {
        print("Push to: \(route.displayName)")
        path.append(route)
    }
    
    /// 이전 화면으로 돌아가기
    func pop() {
        guard !path.isEmpty else { return }
        print("Pop - 이전 화면으로")
        path.removeLast()
    }
    
    /// 특정 개수만큼 뒤로가기
    func pop(count: Int) {
        guard path.count >= count else {
            path = NavigationPath()
            return
        }
        
        for _ in 0..<count {
            if !path.isEmpty {
                path.removeLast()
            }
        }
        print("Pop \(count)개 화면")
    }
    
    /// 루트로 돌아가기
    func popToRoot() {
        print("popToRoot 호출 - 현재 path.count: \(path.count)")
        path = NavigationPath()
        print("popToRoot 완료 - 새로운 path.count: \(path.count)")
    }
    
    /// 루트로 돌아가면서 특정 탭 선택
    func popToRootAndSelectTab(_ tab: Tab) {
        print("popToRootAndSelectTab 호출 - 탭: \(tab)")
        print("현재 path.count: \(path.count)")
        
        path = NavigationPath()
        
        print("NotificationCenter에 selectTab 이벤트 발송")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: .selectTab, object: tab)
            print("selectTab 이벤트 발송 완료")
        }
    }
    
    /// 특정 화면까지 뒤로가기 
    func popTo(_ targetRoute: RecommendRoute) {
        popToRoot()
    }
}


extension Notification.Name {
    static let selectTab = Notification.Name("selectTab")
}
