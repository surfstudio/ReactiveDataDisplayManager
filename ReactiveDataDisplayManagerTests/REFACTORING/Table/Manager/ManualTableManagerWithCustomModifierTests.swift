//
//  ManualTableManagerWithCustomModifierTests.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import XCTest
@testable import ReactiveDataDisplayManager

final class ManualTableManagerWithCustomModifierTests: XCTestCase {

    private var ddm: ManualTableManager!
    private var table: UITableViewSpy!
    private var modifier: MockTableModifier!

    override func setUp() {
        super.setUp()
        table = UITableViewSpy()
        modifier = MockTableModifier(view: table)
        ddm = table.rddm.manualBuilder
            .set(dataSource: { [unowned self] in MockTableDataSourceWithModifier(manager: $0, modifier: modifier) })
            .build()
    }

    override func tearDown() {
        super.tearDown()
        table = nil
        ddm = nil
    }

    func testThatUpdateGeneratorsUpdatesNeededGenerators() {
        // given
        let headerGen1 = MockTableHeaderGenerator()
        let gen1 = MockTableCellGenerator()
        let gen2 = MockTableCellGenerator()
        let headerGen2 = MockTableHeaderGenerator()
        let gen3 = MockTableCellGenerator()
        let gen4 = MockTableCellGenerator()
        let gen5 = MockTableCellGenerator()
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2])
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4, gen5])

        // when
        ddm.update(generators: [gen1, gen4])

        // then
        print(modifier.lastReloadedRows)
        XCTAssertEqual(modifier.lastReloadedRows, [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 1)])
    }

    func testThatReloadSectionCallTableViewMethod() {
        // Arrange
        let headerGenerator = MockTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)

        // Act
        ddm.reloadSection(by: headerGenerator)

        // Assert
        XCTAssertTrue(modifier.sectionWasReloaded)
    }

    func testThatReloadSectionWithInvalidHeaderGeneratorNotCallTableViewMethod() {
        // Arrange
        let headerGenerator = MockTableHeaderGenerator()
        let wrongHeaderGenerator = MockTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)

        // Act
        ddm.reloadSection(by: wrongHeaderGenerator)

        // Assert
        XCTAssertFalse(modifier.sectionWasReloaded)
    }

}
