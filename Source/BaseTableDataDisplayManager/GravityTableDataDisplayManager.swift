//
//  GravityTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 17.10.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import UIKit

/// Contains implementations DataDisplayManager and HeaderDisplayManager with weight parameters for sorting.
open class GravityTableDataDisplayManager: NSObject, DataDisplayManager, HeaderDataDisplayManager {

    // MARK: - Types

    public typealias CollectionType = UITableView
    public typealias CellGeneratorType = GravityTableCellGenerator
    public typealias HeaderGeneratorType = GravityTableHeaderGenerator

    // MARK: - Events

    public let scrolledByOffset = BaseEvent<CGFloat>()

    // MARK: - Public Properties

    public var estimatedHeight: CGFloat = 40.0
    public weak var tableView: UITableView?
    public private(set) var cellGenerators: [[GravityTableCellGenerator]]
    public private(set) var headerGenerators: [GravityTableHeaderGenerator]

    // MARK: - DataDisplayManager

    public required init(collection: UITableView) {
        self.tableView = collection
        self.cellGenerators = [[]]
        self.headerGenerators = []
        super.init()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }

    public func forceRefill() {
        tableView?.reloadData()
    }

    public func forceRefill(completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        self.forceRefill()
        CATransaction.commit()
    }

    public func addCellGenerator(_ generator: GravityTableCellGenerator) {
        guard
            checkDuplicate(generator: generator),
            let tableView = self.tableView
        else {
            return
        }

        generator.registerCell(in: tableView)

        if cellGenerators.count != headerGenerators.count || headerGenerators.isEmpty {
            cellGenerators.append([GravityTableCellGenerator]())
        }

        if headerGenerators.isEmpty {
            headerGenerators.append(EmptyGravityTableHeaderGenerator())
        }

        let index = headerGenerators.count - 1
        let currentIndex = index < 0 ? 0 : index
        cellGenerators[currentIndex].append(generator)

        insert(generators: [generator], to: currentIndex)
    }

    public func addCellGenerators(_ generators: [GravityTableCellGenerator], after: GravityTableCellGenerator) {
        generators.reversed().forEach { self.addCellGenerator($0, after: after) }
    }

    public func addCellGenerator(_ generator: GravityTableCellGenerator, after: GravityTableCellGenerator) {

        guard
            let path = indexPath(for: after)
        else {
            assertionFailure("Generator doesn't exist")
            return
        }

        cellGenerators[path.section].insert(generator, at: path.row + 1)

        generator.heaviness = after.heaviness + 1
        cellGenerators[path.section].forEach { gen in
            guard gen.heaviness > generator.heaviness else { return }
            gen.heaviness += 1
        }

        insert(generators: [generator], to: path.section)
    }

    public func addCellGenerators(_ generators: [GravityTableCellGenerator]) {
        generators.forEach { self.addCellGenerator($0) }
    }

    public func update(generators: [GravityTableCellGenerator]) {
        let indexPaths = generators.compactMap { self.indexPath(for: $0) }
        tableView?.reloadRows(at: indexPaths, with: .none)
    }

    public func clearCellGenerators() {
        cellGenerators.removeAll()
    }

    // MARK: - HeaderDataDisplayManager

    public func addSectionHeaderGenerator(_ generator: GravityTableHeaderGenerator) {
        checkDuplicate(header: generator)
        headerGenerators.append(generator)

        if cellGenerators.count != headerGenerators.count || headerGenerators.isEmpty {
            cellGenerators.append([GravityTableCellGenerator]())
        }

        let combined = zip(headerGenerators, cellGenerators).sorted { lhs, rhs in lhs.0.getHeaviness() < rhs.0.getHeaviness()
        }

        headerGenerators = combined.map { $0.0 }
        cellGenerators = combined.map { $0.1 }
    }

    public func addCellGenerator(_ generator: GravityTableCellGenerator, toHeader header: GravityTableHeaderGenerator) {
        guard checkDuplicate(generator: generator) else { return }
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [GravityTableCellGenerator], toHeader header: GravityTableHeaderGenerator) {
        guard let tableView = self.tableView else { return }

       generators.forEach { $0.registerCell(in: tableView) }

       if cellGenerators.count != headerGenerators.count || headerGenerators.isEmpty {
           cellGenerators.append([GravityTableCellGenerator]())
       }

       if let index = headerGenerators.firstIndex(where: { $0 === header }) {
           cellGenerators[index].append(contentsOf: generators)
           insert(generators: generators, to: index)
       }
    }

    public func removeAllGenerators(from header: GravityTableHeaderGenerator) {
        guard
            let index = self.headerGenerators.index(where: { $0 === header }),
            self.cellGenerators.count > index
        else {
            return
        }

        self.cellGenerators[index].removeAll()
    }

    public func clearHeaderGenerators() {
        headerGenerators.removeAll()
    }

    // MARK: - Public Methods

    open func firstGenerator<T: TableCellGenerator>() -> T? {
        return self.cellGenerators
            .first(where: { $0.contains(where: { gen in gen is T }) })?
            .first(where: { $0 is T }) as? T
    }

    open func lastGenerator<T: TableCellGenerator>() -> T? {
        return self.cellGenerators
            .last(where: { $0.contains(where: { gen in gen is T }) })?
            .last(where: { $0 is T }) as? T
    }

    open func generators<T: TableCellGenerator>(for type: T.Type) -> [T]? {
        return cellGenerators.flatMap { $0.compactMap { $0 as? T } }
    }

    open func headers<T: TableHeaderGenerator>(for type: T.Type) -> [T]? {
        return headerGenerators.compactMap { $0 as? T }
    }

    open func replace(oldGenerator: GravityTableCellGenerator,
                 on newGenerator: GravityTableCellGenerator,
                 removeAnimation: UITableView.RowAnimation = .automatic,
                 insertAnimation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(oldGenerator), let table = self.tableView else { return }

        table.beginUpdates()
        self.cellGenerators[index.sectionIndex].remove(at: index.generatorIndex)
        self.cellGenerators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: removeAnimation)
        table.insertRows(at: [indexPath], with: insertAnimation)
        table.endUpdates()
    }

    open func replace(header: GravityTableHeaderGenerator, with animation: UITableView.RowAnimation = .fade) {
        guard let indexOfHeader = self.headerGenerators.firstIndex(where: { $0 === header }) else {
            self.addSectionHeaderGenerator(header)
            return
        }

        self.headerGenerators[indexOfHeader] = header
        self.tableView?.reloadSections(IndexSet(arrayLiteral: indexOfHeader), with: animation)
    }

    open func remove(_ generator: TableCellGenerator,
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

private extension GravityTableDataDisplayManager {
    func checkDuplicate(header: GravityTableHeaderGenerator) {
        guard
            !headerGenerators.contains(where: { $0.getHeaviness() == header.getHeaviness() })
        else {
            assertionFailure("Unique heaviness expected for \(header)")
            return
        }
    }

    func checkDuplicate(generator: GravityTableCellGenerator) -> Bool {
        return !cellGenerators.contains(where: { section in
                section.contains { $0.heaviness == generator.heaviness }
            })
    }

    func insert(generators: [GravityTableCellGenerator], to section: Int) {
        guard !generators.isEmpty else { return }

        cellGenerators[section].sort { $0.heaviness < $1.heaviness }

        let indexPaths = generators.compactMap { generator -> IndexPath? in
            guard
                let index = self.nearestIndex(for: generator, in: section)
            else {
                return nil
            }
            return IndexPath(row: index, section: section)
        }

        tableView?.insertRows(at: indexPaths, with: .none)
    }

    func nearestIndex(for generator: GravityTableCellGenerator, in section: Int) -> Int? {
        let nearestIndex = cellGenerators[section].enumerated().min { lhs, rhs in
            let lhsValue = abs(lhs.element.heaviness - generator.heaviness)
            let rhsValue = abs(rhs.element.heaviness - generator.heaviness)
            return lhsValue < rhsValue
        }

        return nearestIndex?.offset
    }

    func indexPath(for generator: GravityTableCellGenerator) -> IndexPath? {
        for (sectionIndex, section) in cellGenerators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return IndexPath(row: generatorIndex, section: sectionIndex)
            }
        }

        return nil
    }

    func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in cellGenerators.enumerated() {
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
        self.cellGenerators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: animation)

        // scroll if needed
        if let scrollPosition = scrollPosition {
            table.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }

        table.endUpdates()
    }
}

// MARK: - UITableViewDataSource

extension GravityTableDataDisplayManager: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return headerGenerators.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellGenerators.indices.contains(section) {
            return cellGenerators[section].count
        } else {
            return 0
        }
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellGenerators[indexPath.section][indexPath.row].generate(tableView: tableView,
                                                                         for: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension GravityTableDataDisplayManager: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellGenerators[indexPath.section][indexPath.row].cellHeight
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > headerGenerators.count - 1 {
            return nil
        }
        return headerGenerators[section].generate()
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > headerGenerators.count - 1 {
            return 0.01
        }

        return headerGenerators[section].height(tableView, forSection: section)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let selectable = cellGenerators[indexPath.section][indexPath.row] as? SelectableItem else {
            return
        }

        selectable.didSelectEvent.invoke(with: ())

        if selectable.isNeedDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrolledByOffset.invoke(with: scrollView.contentOffset.y)
    }
}

