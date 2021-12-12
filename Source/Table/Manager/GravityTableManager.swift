//
//  GravityTableManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 23.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

extension EmptyTableHeaderGenerator: GravityItem {
    public func getHeaviness() -> Int {
        .zero
    }

    // swiftlint:disable unused_setter_value
    public var heaviness: Int {
        get { return self.getHeaviness() }
        set { fatalError() }
    }
    // swiftlint:enable unused_setter_value
}

/// DataDisplayManager for UITableView
/// Warning. Do not forget to conform TableCellGenerator to GravityItem (GravityTableCellGenerator)
open class GravityTableManager: BaseTableManager {

    public typealias CellGeneratorType = GravityTableCellGenerator
    public typealias HeaderGeneratorType = GravityTableHeaderGenerator

    // MARK: - Public methods

    open override func addCellGenerator(_ generator: TableCellGenerator) {
        assert(generator is CellGeneratorType, "This strategy support only \(CellGeneratorType.Type.self)")

        guard
            let gravityGenerator = generator as? CellGeneratorType,
            checkDuplicate(generator: gravityGenerator),
            let tableView = view
        else {
            return
        }

        generator.registerCell(in: tableView)
        addTableGenerators(with: [generator], choice: .lastSection)

        let index = sections.count - 1
        let currentIndex = index < 0 ? 0 : index
        insert(generators: [gravityGenerator], to: currentIndex)
    }

    open override func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        generators.reversed().forEach {
            $0.registerCell(in: view)
            addCellGenerator($0, after: after)
        }
    }

    open override func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        assert(generator is CellGeneratorType, "This strategy support only \(CellGeneratorType.Type.self)")
        assert(after is CellGeneratorType, "This strategy support only \(CellGeneratorType.Type.self)")

        guard let gravityGenerator = generator as? CellGeneratorType,
              let gravityGeneratorAfter = after as? CellGeneratorType,
              let path = indexPath(for: gravityGeneratorAfter)
        else {
            assertionFailure("Generator doesn't exist")
            return
        }

        sections[path.section].generators.insert(generator, at: path.row + 1)

        gravityGenerator.heaviness = gravityGeneratorAfter.heaviness + 1
        getOldSections().generators.asGravityCellCompatible[path.section].forEach { gen in
            guard gen.heaviness > gravityGenerator.heaviness else { return }
            gen.heaviness += 1
        }

        insert(generators: [gravityGenerator], to: path.section)
    }

    // MARK: - HeaderDataDisplayManager

    public func addSectionHeaderGenerator(_ generator: HeaderGeneratorType) {
        checkDuplicate(header: generator)
        addHeader(header: generator)

        let combined = zip(getOldSections().headers.asGravityHeaderCompatible, sections).sorted { lhs, rhs in
            lhs.0.getHeaviness() < rhs.0.getHeaviness()
        }

//        headers = combined.map { $0.0 }
//        generators = combined.map { $0.1 }
    }

    public func addCellGenerator(_ generator: CellGeneratorType, toHeader header: HeaderGeneratorType) {
        guard checkDuplicate(generator: generator) else { return }
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [CellGeneratorType], toHeader header: HeaderGeneratorType) {
        guard let tableView = self.view else { return }

        generators.forEach { $0.registerCell(in: tableView) }

        if let index = sections.firstIndex(where: { $0.header === header }) {
            self.sections[index].generators.append(contentsOf: generators)
            insert(generators: generators, to: index)
        }
    }

    public func removeAllgenerators(from header: HeaderGeneratorType) {
        guard
            let index = self.sections.firstIndex(where: { $0.header === header }),
            self.sections.count > index
        else {
            return
        }

        self.sections[index].generators.removeAll()
    }

    public func clearHeaderGenerators() {
        for (index, _) in sections.enumerated() {
            sections[index].header = EmptyTableHeaderGenerator()
        }
    }

    open func replace(oldGenerator: CellGeneratorType,
                      on newGenerator: CellGeneratorType,
                      removeAnimation: UITableView.RowAnimation = .automatic,
                      insertAnimation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(oldGenerator) else { return }

        sections[index.sectionIndex].generators.remove(at: index.generatorIndex)
        sections[index.sectionIndex].generators.insert(newGenerator, at: index.generatorIndex)

        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        dataSource?.modifier?.replace(at: indexPath, with: removeAnimation, and: insertAnimation)
    }

    open func replace(header: HeaderGeneratorType, with animation: UITableView.RowAnimation = .fade) {
        guard let indexOfHeader = self.sections.firstIndex(where: { $0.header === header }) else {
            self.addSectionHeaderGenerator(header)
            return
        }

        self.sections[indexOfHeader].header = header
        dataSource?.modifier?.reloadSections(at: [indexOfHeader], with: animation)
    }

    open func remove(_ generator: CellGeneratorType,
                     with animation: UITableView.RowAnimation = .automatic,
                     needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                     needRemoveEmptySection: Bool = false) {
        guard let index = self.findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             with: animation,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

}

// MARK: - Private

private extension GravityTableManager {

    func checkDuplicate(header: HeaderGeneratorType) {
        guard
            !getOldSections().headers.asGravityHeaderCompatible.contains(where: { $0.getHeaviness() == header.getHeaviness() })
        else {
            assertionFailure("Unique heaviness expected for \(header)")
            return
        }
    }

    func checkDuplicate(generator: CellGeneratorType) -> Bool {
        return !getOldSections().generators.asGravityCellCompatible.contains(where: { section in
            section.contains { $0.heaviness == generator.heaviness }
        })
    }

    func insert(generators: [CellGeneratorType], to section: Int) {
        guard !generators.isEmpty else { return }

        self.sections[section].generators = self.getOldSections().generators.asGravityCellCompatible[section].sorted { $0.heaviness < $1.heaviness }

        let indexPaths = generators.compactMap { generator -> IndexPath? in
            guard
                let index = self.nearestIndex(for: generator, in: section)
            else {
                return nil
            }
            return IndexPath(row: index, section: section)
        }

        dataSource?.modifier?.insertRows(at: indexPaths, with: .none)
    }

    func nearestIndex(for generator: CellGeneratorType, in section: Int) -> Int? {
        let nearestIndex = getOldSections().generators.asGravityCellCompatible[section].enumerated().min { lhs, rhs in
            let lhsValue = abs(lhs.element.heaviness - generator.heaviness)
            let rhsValue = abs(rhs.element.heaviness - generator.heaviness)
            return lhsValue < rhsValue
        }

        return nearestIndex?.offset
    }

    func indexPath(for generator: CellGeneratorType) -> IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            if let generatorIndex = section.generators.firstIndex(where: { $0 === generator }) {
                return IndexPath(row: generatorIndex, section: sectionIndex)
            }
        }

        return nil
    }

}

// MARK: - Adapter

fileprivate extension Array where Element == [TableCellGenerator] {

    var asGravityCellCompatible: [[GravityTableManager.CellGeneratorType]] {
        map { cells in
            cells.compactMap {
                $0 as? GravityTableManager.CellGeneratorType
            }
        }
    }

}

fileprivate extension Array where Element: TableCellGenerator {

    var asGravityCellCompatible: [GravityTableManager.CellGeneratorType] {
        compactMap {
            $0 as? GravityTableManager.CellGeneratorType
        }
    }

}

fileprivate extension Array where Element: TableHeaderGenerator {

    var asGravityHeaderCompatible: [GravityTableManager.HeaderGeneratorType] {
        compactMap {
            $0 as? GravityTableManager.HeaderGeneratorType
        }
    }

}
