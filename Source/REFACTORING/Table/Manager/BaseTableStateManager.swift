////
////  BaseTableStateManager.swift
////  ReactiveDataDisplayManager
////
////  Created by Aleksandr Smirnov on 02.11.2020.
////  Copyright © 2020 Александр Кравченков. All rights reserved.
////

import Foundation

open class BaseTableStateManager: TableStateManager {

    public typealias CollectionType = UITableView
    public typealias CellGeneratorType = TableCellGenerator
    public typealias HeaderGeneratorType = TableHeaderGenerator

    // MARK: - Public properties

    weak var tableView: UITableView?

    public var generators: [[TableCellGenerator]]
    public var sections: [TableHeaderGenerator]

    var delegate: BaseTableDelegate?
    var dataSource: BaseTableDataSource?

    public init() {
        generators = [[TableCellGenerator]]()
        sections = [TableHeaderGenerator]()
    }

    // MARK: - DataDisplayManager

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

    open func addCellGenerator(_ generator: TableCellGenerator) {
        guard let table = tableView else { return }
        generator.registerCell(in: table)
        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([TableCellGenerator]())
        }
        if sections.count <= 0 {
            sections.append(EmptyTableHeaderGenerator())
        }
        // Add to last section
        let index = sections.count - 1
        self.generators[index < 0 ? 0 : index].append(generator)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        guard let table = tableView else { return }
        generators.forEach { $0.registerCell(in: table) }
        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            fatalError("Error adding TableCellGenerator generator. You tried to add generators after unexisted generator")
        }
        self.generators[sectionIndex].insert(contentsOf: generators, at: generatorIndex + 1)
    }

    open func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        addCellGenerators([generator], after: after)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator]) {
        for generator in generators {
            self.addCellGenerator(generator)
        }
    }

    open func update(generators: [TableCellGenerator]) {
        let indexes = generators.compactMap { [weak self] in self?.findGenerator($0) }
        let indexPaths = indexes.compactMap { IndexPath(row: $0.generatorIndex, section: $0.sectionIndex) }
        tableView?.reloadRows(at: indexPaths, with: .none)
    }

    open func clearCellGenerators() {
        generators.removeAll()
    }

    /// Removes generator from data display manager. Generators compares by references.
    ///
    /// - Parameters:
    ///   - generator: Generator to delete.
    ///   - animation: Animation for row action.
    ///   - needScrollAt: If not nil than performs scroll before removing generator.
    /// A constant that identifies a relative position in the table view (top, middle, bottom)
    /// for row when scrolling concludes. See UITableViewScrollPosition for descriptions of valid constants.
    ///   - needRemoveEmptySection: Pass **true** if you need to remove section if it'll be empty after deleting.
    open func remove(_ generator: TableCellGenerator, with animation: UITableView.RowAnimation, needScrollAt scrollPosition: UITableView.ScrollPosition?, needRemoveEmptySection: Bool) {
        guard let index = findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             with: animation,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

}

// MARK: - Helper

extension BaseTableStateManager {

    func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in generators.enumerated() {
            if let generatorIndex = section.index(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

    func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                         with animation: UITableView.RowAnimation = .automatic,
                         needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                         needRemoveEmptySection: Bool = false) {
        guard let table = tableView else { return }

        // perform update
        table.beginUpdates()
        self.generators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: animation)

        // remove empty section if needed
        if needRemoveEmptySection && self.generators[index.sectionIndex].isEmpty {
            self.generators.remove(at: index.sectionIndex)
            self.sections.remove(at: index.sectionIndex)
            table.deleteSections(IndexSet(integer: index.sectionIndex), with: animation)
        }

        // scroll if needed
        if let scrollPosition = scrollPosition {
            table.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }

        table.endUpdates()
    }

}