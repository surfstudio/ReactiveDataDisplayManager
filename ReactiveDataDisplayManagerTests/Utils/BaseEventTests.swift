//
//  BaseEventTests.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 26.06.2023.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class BaseEventTests: XCTestCase {

    func testWhenNListnersThenNEvents() {
        // given

        let event = BaseEvent<Int>()
        let n = 100
        var eventHandled = 0

        for _ in 0..<n {
            event.addListner({ _ in eventHandled += 1 })
        }

        // when

        event.invoke(with: 0)

        // then

        XCTAssertEqual(eventHandled, n)
    }

    func testWhenNListnersThenClear() {
        // given

        let event = BaseEvent<Int>()
        let n = 100

        for _ in 0..<n {
            event.addListner({ _ in })
        }

        // when

        event.clear()

        // then

        XCTAssertTrue(event.isEmpty)
    }

    func testWhenUniqueListnerThenReplaced() {
        // given

        let event = BaseEvent<Int>()
        let id = "uniqueId"
        var result = 0

        event.addListner(with: id) { _ in
            result = 1
        }

        // when

        event.addListner(with: id) { _ in
            result = 2
        }
        event.invoke(with: 0)

        // then

        XCTAssertEqual(result, 2)
        XCTAssertEqual(event.count, 1)
    }

    func testWhenNUniqueListnersThenReplaced() {
        // given

        let event = BaseEvent<Int>()
        let n = 100
        let ids = Array(repeating: 0, count: n).map { _ in UUID().uuidString }

        ids.forEach { event.addListner(with: $0, { _ in }) }

        // when

        ids.forEach { event.addListner(with: $0, { _ in }) }

        // then

        XCTAssertEqual(event.count, n)
    }

}
