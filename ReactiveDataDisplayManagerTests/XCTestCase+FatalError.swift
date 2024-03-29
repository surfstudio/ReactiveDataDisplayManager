//
//  XCTestCase+FatalError.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Ivan Smetanin on 25/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import XCTest
@testable import ReactiveDataDisplayManager

extension XCTestCase {

    func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {

        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String?

        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: testcase)

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(assertionMessage, expectedMessage)

            FatalErrorUtil.restoreFatalError()
        }
    }

}
