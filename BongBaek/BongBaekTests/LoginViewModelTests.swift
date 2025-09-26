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
}
