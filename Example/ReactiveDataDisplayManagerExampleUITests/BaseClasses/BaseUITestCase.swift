//
//  BaseUITestCase.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by porohov on 14.06.2022.
//

import XCTest

open class BaseUITestCase: XCTestCase {

    enum CollectionType {
        case table, collection
    }

    //swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    var additionalCommands: [String] = []

    override open func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launchArguments.append(contentsOf: additionalCommands)
        app.launch()
    }

    func setTab(_ screenName: String) {
        app.tabBars.buttons[screenName].tap()
    }

    func tapTableElement(_ screenName: String) {
        app.tables.staticTexts[screenName].tap()
    }

    func tapFirstCell(by collection: CollectionType) {
        let collection = (collection == .collection ? app.collectionViews : app.tables).firstMatch
        collection.cells.firstMatch.tap()
    }

    func tapButton(_ screenName: String) {
        app.buttons[screenName].tap()
    }

    func getFirstCell(for collection: CollectionType, id: String) -> XCUIElement {
        let collection = (collection == .collection ? app.collectionViews : app.tables)
            .matching(identifier: id)
        return collection.cells.firstMatch
    }

    func getCell(for collection: CollectionType, collectionId: String, cellId: String) -> XCUIElement {
        let collection = (collection == .collection ? app.collectionViews : app.tables)
            .matching(identifier: collectionId)
        return collection.cells.element(matching: .cell, identifier: cellId)
    }

}
