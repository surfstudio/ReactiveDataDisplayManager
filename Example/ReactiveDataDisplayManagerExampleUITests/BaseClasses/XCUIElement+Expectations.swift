//
//  XCUIElement+Expectations.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Никита Коробейников on 19.12.2022.
//

import XCTest

extension XCUIElement {

    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        return result == .completed
    }

}
