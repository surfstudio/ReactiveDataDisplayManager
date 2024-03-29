//
//  XCUIElement+Extensions.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Никита Коробейников on 19.12.2022.
//

import XCTest

extension XCUIElement {

    var stringValue: String? {
        value as? String
    }

    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        return result == .completed
    }

    func waitForLabelEqualTo(_ expectedLabel: String, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "label == %@", expectedLabel)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        return result == .completed
    }

}
