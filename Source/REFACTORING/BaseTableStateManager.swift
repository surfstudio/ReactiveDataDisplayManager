//
//  BaseTableStateManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

//Base implementation of a TableStateManager. Handles all operations with generators and sections.
open class BaseTableStateManager: AbstractStateManager {

    // MARK: - Public properties

    weak var adapter: BaseTableAdapter?

    public var generators: [[TableCellGenerator]]
    public var sections: [TableHeaderGenerator]

    // MARK: - Initialization

    public init() {
        self.generators = [[TableCellGenerator]]()
        self.sections = [TableHeaderGenerator]()
    }

    // MARK: - State Management Methods

    /// Adds section header generator and its section's generators to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for new section header.
    ///   - cells: Generators for this section.
    open func addSection(header generator: TableHeaderGenerator, cells: [TableCellGenerator]) {
        guard let table = adapter?.tableView else { return }
        cells.forEach { $0.registerCell(in: table) }
        self.sections.append(generator)
        self.generators.append(cells)
    }

    /// Adds section header generator  to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for new section header.
    open func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
        self.sections.append(generator)
    }

    /// Inserts new header generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: Header which you want to insert.
    ///   - after: Header, after which new header will be added.
    open func insert(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding header generator. Header generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === after }) else {
            fatalError("Error adding header generator. You tried to add generators after unexisted generator")
        }
        let newIndex = anchorIndex + 1
        self.insert(headGenerator: headGenerator, by: newIndex)
    }

    /// Inserts new header generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: Header which you want to insert.
    ///   - after: Header, before which new header will be added.
    open func insert(headGenerator: TableHeaderGenerator, before: TableHeaderGenerator) {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding header generator. Header generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === before }) else {
            fatalError("Error adding header generator. You tried to add generators after unexisted generator")
        }
        let newIndex = max(anchorIndex - 1, 0)
        self.insert(headGenerator: headGenerator, by: newIndex)
    }

    open func addCellGenerator(_ generator: TableCellGenerator) {
        guard let table = adapter?.tableView else { return }
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

    open func addCellGenerators(_ generators: [TableCellGenerator]) {
        for generator in generators {
            self.addCellGenerator(generator)
        }
    }

    open func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        addCellGenerators([generator], after: after)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        guard let table = adapter?.tableView else { return }
        generators.forEach { $0.registerCell(in: table) }
        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            fatalError("Error adding cell generator. You tried to add generators after unexisted generator")
        }
        self.generators[sectionIndex].insert(contentsOf: generators, at: generatorIndex + 1)
    }

    open func update(generators: [TableCellGenerator]) {
        let indexes = generators.compactMap { [weak self] in self?.findGenerator($0) }
        let indexPaths = indexes.compactMap { IndexPath(row: $0.generatorIndex, section: $0.sectionIndex) }
        self.adapter?.tableView.reloadRows(at: indexPaths, with: .none)
    }

    open func clearCellGenerators() {
        self.generators.removeAll()
    }

    /// Removes all headers generators
    open func clearHeaderGenerators() {
        self.sections.removeAll()
    }

    open func forceRefill() {
        self.adapter?.tableView.reloadData()
    }

    open func forceRefill(completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        self.forceRefill()
        CATransaction.commit()
    }

    /// Reloads only one section with specified animation
    ///
    /// - Parameters:
    ///   - sectionHeaderGenerator: Header of section which you want to reload.
    ///   - animation: Type of reload animation
    open func reloadSection(by sectionHeaderGenerator: TableHeaderGenerator, with animation: UITableView.RowAnimation = .none) {
        guard let index = sections.firstIndex(where: { (headerGenerator) -> Bool in
            return headerGenerator === sectionHeaderGenerator
        }) else { return }
        self.adapter?.tableView.reloadSections(IndexSet(integer: index), with: animation)
    }

    /// Inserts new generators to provided header generator.
    ///
    /// - Parameters:
    ///   - generators: Generators to insert
    ///   - header: Header generator in which you want to insert.
    open func addCellGenerators(_ generators: [TableCellGenerator], toHeader header: TableHeaderGenerator) {
        guard let table = self.adapter?.tableView else { return }
        generators.forEach { $0.registerCell(in: table) }

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([TableCellGenerator]())
        }

        if let index = self.sections.index(where: { $0 === header }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    /// Removes all cell generators from a given section
    open func removeAllGenerators(from header: TableHeaderGenerator) {
        guard let index = self.sections.index(where: { $0 === header }), self.generators.count > index else {
            return
        }

        self.generators[index].removeAll()
    }

    open func addCellGenerator(_ generator: TableCellGenerator, toHeader header: TableHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
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
                     with animation: UITableView.RowAnimation = .automatic,
                     needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                     needRemoveEmptySection: Bool = false) {
        guard let index = self.findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             with: animation,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

    /// Inserts new head generator.
    ///
    /// - Parameters:
    ///   - headGenerator: Header which you want to insert.
    ///   - by: Index which new header will be added.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insert(headGenerator: TableHeaderGenerator,
                     by index: Int,
                     generators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: headGenerator, by: index, animation: animation)
        guard let headerIndex = self.sections.index(where: { $0 === headGenerator }) else {
            return
        }

        let elements = generators.enumerated().map {
            ($0.element, headerIndex, $0.offset)
        }

        self.insert(elements: elements, with: animation)
    }

    /// Inserts new section.
    ///
    /// - Parameters:
    ///   - before: Header before which new section will be added.
    ///   - new: Header which you want to insert before current header.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(before header: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: sectionHeader, before: header)

        guard let headerIndex = self.sections.index(where: {
            $0 === sectionHeader
        }) else {
            return
        }

        let elements = generators.enumerated().map {
            ($0.element, headerIndex, $0.offset)
        }

        self.insert(elements: elements, with: animation)
    }

    /// Inserts new section.
    ///
    /// - Parameters:
    ///   - after: Header after which new section will be added.
    ///   - new: Header which you want to insert after current header.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(after header: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: sectionHeader, after: header)

        guard let headerIndex = self.sections.index(where: {
            $0 === sectionHeader
        }) else {
            return
        }

        let elements = generators.enumerated().map { item in
            (item.element, headerIndex, item.offset)
        }

        self.insert(elements: elements, with: animation)
    }

    /// Inserts new generators after provided generator.
    ///
    /// - Parameters:
    ///   - after: Generator after which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(after generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }

        let elements = newGenerators.enumerated().map { item in
            (item.element, index.sectionIndex, index.generatorIndex + item.offset + 1)
        }
        self.insert(elements: elements, with: animation)
    }

    /// Inserts new generators before provided generator.
    ///
    /// - Parameters:
    ///   - before: Generator before which new generators will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert before current generator.
    ///   - with: Animation for row action.
    open func insert(before generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }
        let elements = newGenerators.enumerated().map { item in
            (item.element, index.sectionIndex, index.generatorIndex + item.offset)
        }
        self.insert(elements: elements, with: animation)
    }

    /// Inserts new generator after provided generator.
    ///
    /// - Parameters:
    ///   - after: Generator after which new generator will be added. Must be in the DDM.
    ///   - new: Generator which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(after generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }
        self.insert(elements: [(newGenerator, index.sectionIndex, index.generatorIndex + 1)], with: animation)
    }

    /// Inserts new generator before provided generator.
    ///
    /// - Parameters:
    ///   - after: Generator before which new generator will be added. Must be in the DDM.
    ///   - new: Generator which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(before generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }
        self.insert(elements: [(newGenerator, index.sectionIndex, index.generatorIndex)], with: animation)
    }

    /// Inserts new generator before provided header.
    ///
    /// - Parameters:
    ///   - to: Header before which new generator will be added. Must be in the DDM.
    ///   - new: Generator which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(to header: TableHeaderGenerator,
                     new generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        guard let headerIndex = self.sections.index(where: { $0 === header }) else {
            return
        }
        self.insert(elements: [(generator, headerIndex, 0)], with: animation)
    }

    /// Inserts new generators before provided header.
    ///
    /// - Parameters:
    ///   - to: Header before which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert before current generator.
    ///   - with: Animation for row action.
    open func insertAtBeginning(to header: TableHeaderGenerator,
                                new generators: [TableCellGenerator],
                                with animation: UITableView.RowAnimation = .automatic) {
        guard let headerIndex = self.sections.index(where: { $0 === header }) else {
            return
        }
        let elements = generators.enumerated().map { item in
            (item.element, headerIndex, item.offset)
        }
        self.insert(elements: elements, with: animation)
    }

    /// Inserts new generators before provided header.
    ///
    /// - Parameters:
    ///   - to: Header before which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insertAtEnd(to header: TableHeaderGenerator,
                          new generators: [TableCellGenerator],
                          with animation: UITableView.RowAnimation = .automatic) {
        guard let headerIndex = self.sections.index(where: { $0 === header }) else {
            return
        }
        let base = self.generators[headerIndex].count
        let elements = generators.enumerated().map { item in
            (item.element, headerIndex, base + item.offset)
        }
        self.insert(elements: elements, with: animation)
    }

    /// Replace an old generator on provided generator.
    ///
    /// - Parameters:
    ///   - oldGenerator: Generator that should be replaced. Must be in the DDM.
    ///   - newGenerator: Generator that should be added instead an old generator.
    ///   - removeAnimation: Animation for remove action.
    ///   - insertAnimation: Animation for insert action.
    open func replace(oldGenerator: TableCellGenerator,
                      on newGenerator: TableCellGenerator,
                      removeAnimation: UITableView.RowAnimation = .automatic,
                      insertAnimation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(oldGenerator), let table = self.adapter?.tableView else { return }

        table.beginUpdates()
        self.generators[index.sectionIndex].remove(at: index.generatorIndex)
        self.generators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        table.deleteRows(at: [indexPath], with: removeAnimation)
        table.insertRows(at: [indexPath], with: insertAnimation)
        table.endUpdates()
    }

    /// Swaps two generators between each other.
    ///
    /// - Warning: Calls reload data in tableView.
    ///
    /// - Parameters:
    ///   - firstGenerator: Generator which must to move to new place. Must be in the DDM.
    ///   - secondGenerator: Generator which must to replaced with firstGenerator and move to it place.
    /// Must be in the DDM.
    open func swap(generator firstGenerator: TableCellGenerator, with secondGenerator: TableCellGenerator) {
        guard let firstIndex = findGenerator(firstGenerator), let secondIndex = findGenerator(secondGenerator) else {
            return
        }

        self.generators[firstIndex.sectionIndex].remove(at: firstIndex.generatorIndex)
        self.generators[secondIndex.sectionIndex].remove(at: secondIndex.generatorIndex)

        self.generators[secondIndex.sectionIndex].insert(firstGenerator, at: secondIndex.generatorIndex)
        self.generators[firstIndex.sectionIndex].insert(secondGenerator, at: firstIndex.generatorIndex)

        self.adapter?.tableView.reloadData()
    }

    // MARK: - Private methods

    private func insert(headGenerator: TableHeaderGenerator,
                by index: Int,
                animation: UITableView.RowAnimation = .none) {
        let index = min(max(index, 0), self.sections.count)
        self.sections.insert(headGenerator, at: index)
        self.generators.insert([], at: index)
        self.adapter?.tableView.insertSections([index], with: animation)
    }

    private func insert(elements: [(generator: TableCellGenerator, sectionIndex: Int, generatorIndex: Int)],
                with animation: UITableView.RowAnimation = .automatic) {
        guard let table = self.adapter?.tableView else {
            return
        }

        elements.forEach { [weak self] element in
            element.generator.registerCell(in: table)
            self?.generators[element.sectionIndex].insert(element.generator, at: element.generatorIndex)
        }

        let indexPaths = elements.map {
            IndexPath(row: $0.generatorIndex, section: $0.sectionIndex)
        }

        table.beginUpdates()
        table.insertRows(at: indexPaths, with: animation)
        table.endUpdates()
    }

    // TODO: May be we should remove needScrollAt and move this responsibility to user
    private func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                                 with animation: UITableView.RowAnimation = .automatic,
                                 needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                                 needRemoveEmptySection: Bool = false) {
        guard let table = self.adapter?.tableView else { return }

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

    private func findGenerator(_ generator: TableCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in generators.enumerated() {
            if let generatorIndex = section.index(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

}
