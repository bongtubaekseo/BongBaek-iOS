//
//  LoginViewModelTests.swift
//  BongBaekTests
//
//  Created by 임재현 on 9/26/25.
//

import XCTest
@testable import BongBaek

final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    
    override func setUp() async throws {
        viewModel = await LoginViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testViewModelSuccessfullyInitialization() async {
        XCTAssertNotNil(viewModel, "viewModel이 초기화가 되어서 메세지가 뜨면 안됨")
    }
    
    func testViewModelFailedInitialization() async {
        XCTAssertNil(viewModel, "viewModel이 초기화가 되었는가?- 이 테스트 실패하면 viewModel 초기화 된것")
    }
    
    /// 개인정보처리방침 URL 값이 올바른 값인지 검증하는 함수
    func testPersonaInformationURL_ShouldReturnValidURL() {
        //Given
        let urlString = PrivacyUrls.personalInformationURL.rawValue
        
        //When
        let url = URL(string: urlString)
        
        //Then
        XCTAssertNotNil(url, "개인정보처리방침 URL이 올바르게 생성되지 않았습니다.")
        XCTAssertTrue(isValidURL(url: urlString), "개인정보처리방침 URL은 올바른 포맷이어야합니다.")
    }
    
    /// 이용약관 URL 값이 올바른 값인지 검증하는 함수
    
    func testTermsOfUseURL_ShouldReturnValidURL() {
        //Given
        let urlString = PrivacyUrls.termsOfUseURL.rawValue
        
        //When
        let url = URL(string: urlString)
        
        //Then
        XCTAssertNotNil(url, "이용약관 URL이 올바르게 생성되지 않았습니다.")
        XCTAssertTrue(isValidURL(url: urlString), "이용약관 URL은 올바른 포맷이어야합니다.")
    }
    
    
    // URLOpenr 가 주입이 제대로 되었는지 검증하는 함수
    @MainActor
    func testURLOpener_isInjectedWithDefaultValue() async {
        //Given
        let mockOpener = MockURLOpener()
        let viewModel = LoginViewModel(urlOpener: mockOpener)
        
        //When
        viewModel.openPrivacyPolicy()
        
        //Then
        XCTAssertTrue(mockOpener.openLinkCalled, "openURL 이 호출되었는가")
        XCTAssertEqual(mockOpener.lastOpenURL?.absoluteString,
                       PrivacyUrls.personalInformationURL.rawValue,
                       "openURL 이 올바른지 검증")
    }
}

extension LoginViewModelTests {
    func isValidURL(url: String) -> Bool {
        guard let url = URL(string: url) else {return false}
        
        return url.scheme?.lowercased() == "https" && url.host(percentEncoded: false) != nil
    }
}
