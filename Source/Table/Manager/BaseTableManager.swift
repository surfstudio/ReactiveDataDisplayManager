////
////  BaseTableManager.swift
////  ReactiveDataDisplayManager
////
////  Created by Aleksandr Smirnov on 02.11.2020.
////  Copyright © 2020 Александр Кравченков. All rights reserved.
////

import UIKit

/// Base implementation of DataDisplayManager for UITableView that contains minimal interface
open class BaseTableManager: TableSectionsProvider, DataDisplayManager {

    // MARK: - Typealias

    public typealias CollectionType = UITableView
    public typealias GeneratorType = TableCellGenerator
    public typealias HeaderGeneratorType = TableHeaderGenerator

    // MARK: - Public properties

    // swiftlint:disable implicitly_unwrapped_optional
    public weak var view: UITableView!
    // swiftlint:enable implicitly_unwrapped_optional

    private(set) lazy var registrator: TableRegistrator = .init(view: view)

    var delegate: TableDelegate?
    var dataSource: TableDataSource?

    // MARK: - DataDisplayManager

    public func forceRefill() {
        sections.registerAllIfNeeded(with: view, using: registrator)
        TablePluginsChecker(delegate: delegate, sections: sections).asyncCheckPlugins()
        dataSource?.modifier?.reload()
    }

    open func addCellGenerator(_ generator: TableCellGenerator) {
        addCellGenerators([generator])
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            fatalError("Error adding TableCellGenerator generator. You tried to add generators after unexisted generator")
        }
        self.sections[sectionIndex].generators.insert(contentsOf: generators, at: generatorIndex + 1)
    }

    open func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        addCellGenerators([generator], after: after)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator]) {
        addTableGenerators(with: generators, choice: .lastSection)
    }

    open func update(generators: [TableCellGenerator]) {
        let indexes = generators.compactMap { [weak self] in self?.findGenerator($0) }
        let indexPaths = indexes.compactMap { IndexPath(row: $0.generatorIndex, section: $0.sectionIndex) }

        sections.registerAllIfNeeded(with: view, using: registrator)
        dataSource?.modifier?.reloadRows(at: indexPaths, with: .none)
    }

    open func clearCellGenerators() {
        sections.removeAll()
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
    open func remove(_ generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation,
                     needScrollAt scrollPosition: UITableView.ScrollPosition?,
                     needRemoveEmptySection: Bool) {
        guard let index = findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             with: animation,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

}

// MARK: - Helper

extension BaseTableManager {

    func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in sections.enumerated() {
            if let generatorIndex = section.generators.firstIndex(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

    func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                         with animation: UITableView.RowAnimation = .automatic,
                         needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                         needRemoveEmptySection: Bool = false) {

        sections[index.sectionIndex].generators.remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        // remove empty section if needed
        var sectionIndexPath: IndexSet?
        let sectionIsEmpty = sections[index.sectionIndex].generators.isEmpty
        if needRemoveEmptySection && sectionIsEmpty {
            sections.remove(at: index.sectionIndex)
            sectionIndexPath = IndexSet(integer: index.sectionIndex)
        }

        // apply changes in table
        dataSource?.modifier?.removeRows(at: [indexPath], and: sectionIndexPath, with: animation)

        // scroll if needed
        if let scrollPosition = scrollPosition {
            view.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }
    }

}

// MARK: - Scrolling

public extension BaseTableManager {

    func scrollTo(headGenerator: TableHeaderGenerator, scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard let index = sections.firstIndex(where: { $0.header === headGenerator }) else {
            return
        }
        view?.scrollToRow(at: IndexPath(row: 0, section: index), at: scrollPosition, animated: animated)
    }

    func scrollTo(generator: TableCellGenerator, scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        for sectionElement in sections.enumerated() {
            for rowElement in sectionElement.element.generators.enumerated() {
                if rowElement.element === generator {
                    let indexPath = IndexPath(row: rowElement.offset, section: sectionElement.offset)
                    view?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
                    return
                }
            }
        }
    }

}
