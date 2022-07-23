// swiftlint:disable implicitly_unwrapped_optional force_unwrapping force_cast

import XCTest
@testable import ReactiveDataDisplayManager

final class ManualTableManagerWithCustomModifierTests: XCTestCase {

    private var ddm: ManualTableManager!
    private var table: SpyUITableView!
    private var modifier: SpyTableModifier!

    override func setUp() {
        super.setUp()
        table = SpyUITableView()
        modifier = SpyTableModifier(view: table)
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
        let headerGen1 = StubTableHeaderGenerator()
        let gen1 = StubTableCellGenerator(model: "1")
        let gen2 = StubTableCellGenerator(model: "2")
        let headerGen2 = StubTableHeaderGenerator()
        let gen3 = StubTableCellGenerator(model: "11")
        let gen4 = StubTableCellGenerator(model: "12")
        let gen5 = StubTableCellGenerator(model: "13")
        ddm.addSectionHeaderGenerator(headerGen1)
        ddm.addCellGenerators([gen1, gen2])
        ddm.addSectionHeaderGenerator(headerGen2)
        ddm.addCellGenerators([gen3, gen4, gen5])

        // when
        ddm.update(generators: [gen1, gen4])

        // then
        XCTAssertEqual(modifier.lastReloadedRows, [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 1)])
    }

    func testThatReloadSectionCallTableViewMethod() {
        // Arrange
        let headerGenerator = StubTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)

        // Act
        ddm.reloadSection(by: headerGenerator)

        // Assert
        XCTAssertTrue(modifier.sectionWasReloaded)
    }

    func testThatReloadSectionWithInvalidHeaderGeneratorNotCallTableViewMethod() {
        // Arrange
        let headerGenerator = StubTableHeaderGenerator()
        let wrongHeaderGenerator = StubTableHeaderGenerator()
        ddm.addSectionHeaderGenerator(headerGenerator)

        // Act
        ddm.reloadSection(by: wrongHeaderGenerator)

        // Assert
        XCTAssertFalse(modifier.sectionWasReloaded)
    }

}
