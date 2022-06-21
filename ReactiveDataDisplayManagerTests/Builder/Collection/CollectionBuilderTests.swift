//
//  CollectionBuilderTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import XCTest
@testable import ReactiveDataDisplayManager

class CollectionBuilderTests: XCTestCase {

    private var collection: UICollectionView!

    override func setUp() {
        super.setUp()
        collection = UICollectionView()
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
    }

    func testThatBuilderReturningCollection() {
        let ddm = collection.rddm.baseBuilder.build()

        XCTAssertTrue(ddm.view === collection)
    }

}
