//
//  GravityTableStateManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 23.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

public protocol Gravity: AnyObject {
    var heaviness: Int { get set }

    func getHeaviness() -> Int
}

extension EmptyTableHeaderGenerator: Gravity {
    public func getHeaviness() -> Int {
        .zero
    }

    public var heaviness: Int {
        get {
            return self.getHeaviness()
        }
        set {
            fatalError()
        }
    }
}


open class GravityTableStateManager: BaseTableStateManager {

    public typealias CellGeneratorType = TableCellGenerator & Gravity
    public typealias HeaderGeneratorType = TableHeaderGenerator & Gravity

    // MARK: - Properties

    /// Это все неправда и так не заработает. Нужно абстрагировать StateManager от таблицы
    private var gravityGenerators: [[CellGeneratorType]] = []
    private var gravitySections: [HeaderGeneratorType] = []

    // MARK: - Public methods

    public func addCellGenerator(_ generator: CellGeneratorType) {
        guard
            checkDuplicate(generator: generator),
            let tableView = self.tableView
        else {
            return
        }

        generator.registerCell(in: tableView)

        if gravityGenerators.count != gravitySections.count || gravitySections.isEmpty {
            gravityGenerators.append([CellGeneratorType]())
        }

        if gravitySections.isEmpty {
            gravitySections.append(EmptyTableHeaderGenerator())
        }

        let index = gravitySections.count - 1
        let currentIndex = index < 0 ? 0 : index
        gravityGenerators[currentIndex].append(generator)

        insert(gravityGenerators: [generator], to: currentIndex)
    }

    public func addCellGenerator(_ generator: CellGeneratorType, after: CellGeneratorType) {

        guard
            let path = indexPath(for: after)
        else {
            assertionFailure("Generator doesn't exist")
            return
        }

        gravityGenerators[path.section].insert(generator, at: path.row + 1)

        generator.heaviness = after.heaviness + 1
        gravityGenerators[path.section].forEach { gen in
            guard gen.heaviness > generator.heaviness else { return }
            gen.heaviness += 1
        }

        insert(gravityGenerators: [generator], to: path.section)
    }

    public func addCellgravityGenerators(_ gravityGenerators: [CellGeneratorType]) {
        gravityGenerators.forEach { self.addCellGenerator($0) }
    }

    public func update(gravityGenerators: [CellGeneratorType]) {
        let indexPaths = gravityGenerators.compactMap { self.indexPath(for: $0) }
        tableView?.reloadRows(at: indexPaths, with: .none)
    }

    public func clearCellgravityGenerators() {
        gravityGenerators.removeAll()
    }

    // MARK: - HeaderDataDisplayManager

    public func addSectionHeaderGenerator(_ generator: HeaderGeneratorType) {
        checkDuplicate(header: generator)
        gravitySections.append(generator)

        if gravityGenerators.count != gravitySections.count || gravitySections.isEmpty {
            gravityGenerators.append([CellGeneratorType]())
        }

        let combined = zip(gravitySections, gravityGenerators).sorted { lhs, rhs in
            lhs.0.getHeaviness() < rhs.0.getHeaviness()
        }

        gravitySections = combined.map { $0.0 }
        gravityGenerators = combined.map { $0.1 }
    }

    public func addCellGenerator(_ generator: CellGeneratorType, toHeader header: HeaderGeneratorType) {
        guard checkDuplicate(generator: generator) else { return }
        addCellgravityGenerators([generator], toHeader: header)
    }

    public func addCellgravityGenerators(_ gravityGenerators: [CellGeneratorType], toHeader header: HeaderGeneratorType) {
        guard let tableView = self.tableView else { return }

        gravityGenerators.forEach { $0.registerCell(in: tableView) }

        if self.gravityGenerators.count != gravitySections.count || gravitySections.isEmpty {
            self.gravityGenerators.append([CellGeneratorType]())
        }

        if let index = gravitySections.firstIndex(where: { $0 === header }) {
            self.gravityGenerators[index].append(contentsOf: gravityGenerators)
            insert(gravityGenerators: gravityGenerators, to: index)
        }
    }

    public func removeAllgravityGenerators(from header: HeaderGeneratorType) {
        guard
            let index = self.gravitySections.index(where: { $0 === header }),
            self.gravityGenerators.count > index
        else {
            return
        }

        self.gravityGenerators[index].removeAll()
    }


    public func clearHeadergravityGenerators() {
        gravitySections.removeAll()
    }

    open func replace(oldGenerator: CellGeneratorType,
                 on newGenerator: CellGeneratorType,
                 removeAnimation: UITableView.RowAnimation = .automatic,
                 insertAnimation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(oldGenerator), let table = self.tableView else { return }

        table.beginUpdates()
        self.gravityGenerators[index.sectionIndex].remove(at: index.generatorIndex)
        self.gravityGenerators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: removeAnimation)
        table.insertRows(at: [indexPath], with: insertAnimation)
        table.endUpdates()
    }

    open func replace(header: HeaderGeneratorType, with animation: UITableView.RowAnimation = .fade) {
        guard let indexOfHeader = self.gravitySections.firstIndex(where: { $0 === header }) else {
            self.addSectionHeaderGenerator(header)
            return
        }

        self.gravitySections[indexOfHeader] = header
        self.tableView?.reloadSections(IndexSet(arrayLiteral: indexOfHeader), with: animation)
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

private extension GravityTableStateManager {

    func checkDuplicate(header: HeaderGeneratorType) {
        guard
            !gravitySections.contains(where: { $0.getHeaviness() == header.getHeaviness() })
        else {
            assertionFailure("Unique heaviness expected for \(header)")
            return
        }
    }

    func checkDuplicate(generator: CellGeneratorType) -> Bool {
        return !gravityGenerators.contains(where: { section in
            section.contains { $0.heaviness == generator.heaviness }
        })
    }

    func insert(gravityGenerators: [CellGeneratorType], to section: Int) {
        guard !gravityGenerators.isEmpty else { return }

        self.gravityGenerators[section].sort { $0.heaviness < $1.heaviness }

        let indexPaths = gravityGenerators.compactMap { generator -> IndexPath? in
            guard
                let index = self.nearestIndex(for: generator, in: section)
            else {
                return nil
            }
            return IndexPath(row: index, section: section)
        }

        tableView?.insertRows(at: indexPaths, with: .none)
    }

    func nearestIndex(for generator: CellGeneratorType, in section: Int) -> Int? {
        let nearestIndex = gravityGenerators[section].enumerated().min { lhs, rhs in
            let lhsValue = abs(lhs.element.heaviness - generator.heaviness)
            let rhsValue = abs(rhs.element.heaviness - generator.heaviness)
            return lhsValue < rhsValue
        }

        return nearestIndex?.offset
    }

    func indexPath(for generator: CellGeneratorType) -> IndexPath? {
        for (sectionIndex, section) in gravityGenerators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return IndexPath(row: generatorIndex, section: sectionIndex)
            }
        }

        return nil
    }

    func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in gravityGenerators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

    // TODO: May be we should remove needScrollAt and move this responsibility to user
    func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                         with animation: UITableView.RowAnimation = .automatic,
                         needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                         needRemoveEmptySection: Bool = false) {
        guard let table = self.tableView else { return }

        // perform update
        table.beginUpdates()
        self.gravityGenerators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: animation)

        // scroll if needed
        if let scrollPosition = scrollPosition {
            table.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }

        table.endUpdates()
    }

}
