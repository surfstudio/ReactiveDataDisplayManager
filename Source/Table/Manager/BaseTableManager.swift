////
////  BaseTableManager.swift
////  ReactiveDataDisplayManager
////
////  Created by Aleksandr Smirnov on 02.11.2020.
////  Copyright © 2020 Александр Кравченков. All rights reserved.
////

import UIKit

/// Base implementation of DataDisplayManager for UITableView that contains minimal interface
open class BaseTableManager: TableGeneratorsProvider, DataDisplayManager {

    // MARK: - Typealias

    public typealias CollectionType = UITableView
    public typealias CellGeneratorType = TableCellGenerator
    public typealias HeaderGeneratorType = TableHeaderGenerator
    public typealias FooterGeneratorType = TableFooterGenerator
    public typealias TableModifier = Modifier<CollectionType, CollectionType.RowAnimation>

    // MARK: - Public properties

    // swiftlint:disable implicitly_unwrapped_optional
    public weak var view: CollectionType!
    // swiftlint:enable implicitly_unwrapped_optional

    public var modifier: TableModifier? {
        dataSource?.modifier
    }

    var dataSource: TableDataSource?
    var delegate: TableDelegate?

    // MARK: - DataDisplayManager

    public func forceRefill() {
        TablePluginsChecker(delegate: delegate, generators: generators).asyncCheckPlugins()
        modifier?.reload()
    }

    open func addCellGenerator(_ generator: TableCellGenerator) {
        generator.registerCell(in: view)
        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([TableCellGenerator]())
        }
        if sections.count <= 0 {
            sections.append(EmptyTableHeaderGenerator())
        }
        if footers.count <= 0 {
            footers.append(EmptyTableFooterGenerator())
        }
        // Add to last section
        let index = sections.count - 1
        self.generators[index < 0 ? 0 : index].append(generator)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        generators.forEach { $0.registerCell(in: view) }
        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            return FatalErrorUtil.fatalError("Error adding TableCellGenerator generator. You tried to add generators after unexisted generator")
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
        modifier?.reloadRows(at: indexPaths, with: Optional.none)
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
    open func remove(_ generator: TableCellGenerator,
                     with animation: TableRowAnimation,
                     needScrollAt scrollPosition: UITableView.ScrollPosition?,
                     needRemoveEmptySection: Bool) {
        guard let index = findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             with: animation,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

    // MARK: - HeaderDataDisplayManager

     open func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
         self.sections.append(generator)
         if sections.count > generators.count {
             self.generators.append([])
         }
    }

    open func addCellGenerator(_ generator: CellGeneratorType, toHeader header: TableHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
    }

    open func addCellGenerators(_ generators: [CellGeneratorType], toHeader header: TableHeaderGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([TableCellGenerator]())
        }

        if let index = self.sections.firstIndex(where: { $0 === header }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    open func removeAllGenerators(from header: TableHeaderGenerator) {
        guard
            let index = self.sections.firstIndex(where: { $0 === header }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    open func clearHeaderGenerators() {
        self.sections.removeAll()
    }

    // MARK: - FooterDataDisplayManager

    open func addSectionFooterGenerator(_ generator: TableFooterGenerator) {
        self.footers.append(generator)
    }

    open func addCellGenerator(_ generator: CellGeneratorType, toFooter footer: TableFooterGenerator) {
        addCellGenerators([generator], toFooter: footer)
    }

    open func addCellGenerators(_ generators: [CellGeneratorType], toFooter footer: TableFooterGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.generators.count != self.footers.count || footers.isEmpty {
            self.generators.append([TableCellGenerator]())
        }

        if let index = self.footers.firstIndex(where: { $0 === footer }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    open func removeAllGenerators(from footer: TableFooterGenerator) {
        guard
            let index = self.footers.firstIndex(where: { $0 === footer }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    open func clearFooterGenerators() {
        self.footers.removeAll()
    }

}

// MARK: - Helper

extension BaseTableManager {

    func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in generators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

    func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                         with animation: TableRowAnimation,
                         needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                         needRemoveEmptySection: Bool = false) {

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        // remove empty section if needed
        var sectionIndexPath: IndexSet?
        let sectionIsEmpty = generators[index.sectionIndex].isEmpty
        if needRemoveEmptySection && sectionIsEmpty {
            generators.remove(at: index.sectionIndex)
            sections.remove(at: index.sectionIndex)
            sectionIndexPath = IndexSet(integer: index.sectionIndex)
        }

        // apply changes in table
        modifier?.removeRows(at: [indexPath], and: sectionIndexPath, with: animation.value)

        // scroll if needed
        if let scrollPosition = scrollPosition {
            view.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }
    }

}

// MARK: - Scrolling

public extension BaseTableManager {

    func scrollTo(headGenerator: TableHeaderGenerator, scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard let index = sections.firstIndex(where: { $0 === headGenerator }) else {
            return
        }
        view?.scrollToRow(at: IndexPath(row: 0, section: index), at: scrollPosition, animated: animated)
    }

    func scrollTo(generator: TableCellGenerator, scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        for sectionElement in generators.enumerated() {
            for rowElement in sectionElement.element.enumerated() {
                if rowElement.element === generator {
                    let indexPath = IndexPath(row: rowElement.offset, section: sectionElement.offset)
                    view?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
                    return
                }
            }
        }
    }

}

// MARK: - Internal

extension BaseTableManager {

    // MARK: - Inserting

    func insert(elements: [(generator: TableCellGenerator, sectionIndex: Int, generatorIndex: Int)],
                with animation: TableRowAnimation) {

        elements.forEach { element in
            element.generator.registerCell(in: view)
            generators[element.sectionIndex].insert(element.generator, at: element.generatorIndex)
        }

        let indexPaths = elements.map { IndexPath(row: $0.generatorIndex, section: $0.sectionIndex) }

        modifier?.insertRows(at: indexPaths, with: animation.value)
    }

    func insertManual(after generator: TableCellGenerator,
                      new newGenerators: [TableCellGenerator],
                      with animation: TableRowAnimation) {
        guard let index = self.findGenerator(generator) else { return }

        let elements = newGenerators.enumerated().map { item in
            (item.element, index.sectionIndex, index.generatorIndex + item.offset + 1)
        }
        self.insert(elements: elements, with: animation)
    }

}
