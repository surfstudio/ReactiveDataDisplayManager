//
//  ManualTableManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 25.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Extended implementation of BaseTableManager with replace and insert shortcuts
public class ManualTableManager: BaseTableManager {

    // MARK: - State Management Methods

    /// Adds section TableHeaderGenerator generator and its section's generators to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for new section TableHeaderGenerator.
    ///   - cells: Generators for this section.
    open func addSection(TableHeaderGenerator generator: TableHeaderGenerator, cells: [TableCellGenerator]) {
        cells.forEach { $0.registerCell(in: view) }
        self.sections.append(generator)
        self.generators.append(cells)
    }

    /// Inserts new TableHeaderGenerator generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - after: TableHeaderGenerator, after which new TableHeaderGenerator will be added.
    open func insert(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) {
        let newIndex = getIndexOf(headGenerator: headGenerator, after: after)
        self.insert(headGenerator: headGenerator, by: newIndex, animation: .notAnimated)
    }

    /// Inserts new TableHeaderGenerator generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - after: TableHeaderGenerator, before which new TableHeaderGenerator will be added.
    open func insert(headGenerator: TableHeaderGenerator, before: TableHeaderGenerator) {
        let newIndex = getIndexOf(headGenerator: headGenerator, before: before)
        self.insert(headGenerator: headGenerator, by: newIndex, animation: .notAnimated)
    }

    /// Reloads only one section with specified animation
    ///
    /// - Parameters:
    ///   - sectionHeaderGenerator: TableHeaderGenerator of section which you want to reload.
    ///   - animation: Type of reload animation
    open func reloadSection(by sectionHeaderGenerator: TableHeaderGenerator, with animation: UITableView.RowAnimation = .none) {
        guard let index = sections.firstIndex(where: { (headerGenerator) -> Bool in
            return headerGenerator === sectionHeaderGenerator
        }) else { return }
        modifier?.reloadSections(at: [index], with: animation)
    }

    /// Removes all TableCellGenerator generators from a given section
    open override func removeAllGenerators(from headerGenerator: TableHeaderGenerator) {
        guard let index = self.sections.firstIndex(where: { $0 === headerGenerator }), self.generators.count > index else {
            return
        }

        let generatorsCount = generators[index].count

        self.generators[index].removeAll()

        let indexes = (0..<generatorsCount).map { IndexPath(row: $0, section: index) }

        guard !indexes.isEmpty else {
            return
        }

        modifier?.removeRows(at: indexes, and: nil, with: .automatic)
    }

    /// Inserts new head generator.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - by: Index which new TableHeaderGenerator will be added.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insert(headGenerator: TableHeaderGenerator,
                     by headerIndex: Int,
                     generators: [TableCellGenerator],
                     with animation: TableRowAnimation = .animated(.automatic)) {
        let headerIndex = min(max(headerIndex, 0), self.sections.count)

        self.insert(header: headGenerator, generators: generators, at: headerIndex, with: animation)
    }

    /// Inserts new section.
    ///
    /// - Parameters:
    ///   - before: TableHeaderGenerator before which new section will be added.
    ///   - new: TableHeaderGenerator which you want to insert before current TableHeaderGenerator.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(before headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: TableRowAnimation = .animated(.automatic)) {

        let headerIndex = getIndexOf(headGenerator: sectionHeader, before: headerGenerator)

        self.insert(header: sectionHeader, generators: generators, at: headerIndex, with: animation)
    }

    /// Inserts new section.
    ///
    /// - Parameters:
    ///   - after: TableHeaderGenerator after which new section will be added.
    ///   - new: TableHeaderGenerator which you want to insert after current TableHeaderGenerator.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(after headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: TableRowAnimation = .animated(.automatic)) {
        let headerIndex = getIndexOf(headGenerator: sectionHeader, after: headerGenerator)

        self.insert(header: sectionHeader, generators: generators, at: headerIndex, with: animation)
    }

    /// Inserts new generators after provided generator.
    ///
    /// - Parameters:
    ///   - after: Generator after which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(after generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: TableRowAnimation = .animated(.automatic)) {
        insertManual(after: generator, new: newGenerators, with: animation)
    }

    /// Inserts new generators before provided generator.
    ///
    /// - Parameters:
    ///   - before: Generator before which new generators will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert before current generator.
    ///   - with: Animation for row action.
    open func insert(before generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: TableRowAnimation = .animated(.automatic)) {
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
                     with animation: TableRowAnimation = .animated(.automatic)) {
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
                     with animation: TableRowAnimation = .animated(.automatic)) {
        guard let index = self.findGenerator(generator) else { return }
        self.insert(elements: [(newGenerator, index.sectionIndex, index.generatorIndex)], with: animation)
    }

    /// Inserts new generator before provided TableHeaderGenerator.
    ///
    /// - Parameters:
    ///   - to: TableHeaderGenerator before which new generator will be added. Must be in the DDM.
    ///   - new: Generator which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(to headerGenerator: TableHeaderGenerator,
                     new generator: TableCellGenerator,
                     with animation: TableRowAnimation = .animated(.automatic)) {
        guard let headerIndex = self.sections.firstIndex(where: { $0 === headerGenerator }) else {
            return
        }
        self.insert(elements: [(generator, headerIndex, 0)], with: animation)
    }

    /// Inserts new generators before provided TableHeaderGenerator.
    ///
    /// - Parameters:
    ///   - to: TableHeaderGenerator before which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert before current generator.
    ///   - with: Animation for row action.
    open func insertAtBeginning(to headerGenerator: TableHeaderGenerator,
                                new generators: [TableCellGenerator],
                                with animation: TableRowAnimation = .animated(.automatic)) {
        guard let headerIndex = self.sections.firstIndex(where: { $0 === headerGenerator }) else {
            return
        }
        let elements = generators.enumerated().map { item in
            (item.element, headerIndex, item.offset)
        }
        self.insert(elements: elements, with: animation)
    }

    /// Inserts new generators before provided TableHeaderGenerator.
    ///
    /// - Parameters:
    ///   - to: TableHeaderGenerator before which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insertAtEnd(to headerGenerator: TableHeaderGenerator,
                          new generators: [TableCellGenerator],
                          with animation: TableRowAnimation = .animated(.automatic)) {
        guard let headerIndex = self.sections.firstIndex(where: { $0 === headerGenerator }) else {
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
    ///   - removeInsertAnimation: Animation for remove and insert action.
    open func replace(oldGenerator: TableCellGenerator,
                      on newGenerator: TableCellGenerator,
                      removeInsertAnimation: TableRowAnimationGroup = .animated(.automatic, .automatic)) {
        guard let index = self.findGenerator(oldGenerator) else { return }

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        generators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        modifier?.replace(at: indexPath, with: removeInsertAnimation.value)
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

        generators[firstIndex.sectionIndex].remove(at: firstIndex.generatorIndex)
        generators[secondIndex.sectionIndex].remove(at: secondIndex.generatorIndex)

        generators[secondIndex.sectionIndex].insert(firstGenerator, at: secondIndex.generatorIndex)
        generators[firstIndex.sectionIndex].insert(secondGenerator, at: firstIndex.generatorIndex)

        modifier?.reload()
    }

    // MARK: - Deprecated

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(headGenerator: TableHeaderGenerator,
                     by headerIndex: Int,
                     generators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation) {
        self.insert(headGenerator: headGenerator,
                    by: headerIndex,
                    generators: generators,
                    with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insertSection(before headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation) {
        self.insertSection(before: headerGenerator,
                           new: sectionHeader,
                           generators: generators,
                           with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insertSection(after headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation) {
        self.insertSection(after: headerGenerator,
                           new: sectionHeader,
                           generators: generators,
                           with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(after generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation) {
        insertManual(after: generator, new: newGenerators, with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(before generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation) {
        self.insert(before: generator, new: newGenerators, with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(after generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation) {
        self.insert(after: generator, new: [newGenerator], with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(before generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation) {
        self.insert(before: generator, new: [newGenerator], with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insert(to headerGenerator: TableHeaderGenerator,
                     new generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation) {
        self.insert(to: headerGenerator, new: generator, with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insertAtBeginning(to headerGenerator: TableHeaderGenerator,
                                new generators: [TableCellGenerator],
                                with animation: UITableView.RowAnimation) {
        self.insertAtBeginning(to: headerGenerator, new: generators, with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimation` parameter")
    open func insertAtEnd(to headerGenerator: TableHeaderGenerator,
                          new generators: [TableCellGenerator],
                          with animation: UITableView.RowAnimation) {
        self.insertAtEnd(to: headerGenerator, new: generators, with: .animated(animation))
    }

    @available(*, deprecated, message: "Please use method with a new `TableRowAnimationGroup` parameter")
    open func replace(oldGenerator: TableCellGenerator,
                      on newGenerator: TableCellGenerator,
                      removeAnimation: UITableView.RowAnimation,
                      insertAnimation: UITableView.RowAnimation) {
        self.replace(oldGenerator: oldGenerator,
                     on: newGenerator,
                     removeInsertAnimation: .animated(removeAnimation, insertAnimation))
    }

}

// MARK: - Private

private extension ManualTableManager {

    func getIndexOf(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) -> Int {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === after }) else {
            fatalError("Error adding TableHeaderGenerator generator. You tried to add generators after unexisted generator")
        }
        return anchorIndex + 1
    }

    func getIndexOf(headGenerator: TableHeaderGenerator, before: TableHeaderGenerator) -> Int {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === before }) else {
            fatalError("Error adding TableHeaderGenerator generator. You tried to add generators before unexisted generator")
        }
        return max(anchorIndex - 1, 0)
    }

    func insert(headGenerator: TableHeaderGenerator,
                by index: Int,
                animation: TableRowAnimation) {
        let index = min(max(index, 0), self.sections.count)
        self.sections.insert(headGenerator, at: index)
        self.generators.insert([], at: index)

        modifier?.insertSections(at: [index], with: animation.value)
    }

    func insert(header: TableHeaderGenerator,
                generators: [TableCellGenerator],
                at sectionIndex: Int,
                with animation: TableRowAnimation) {

        generators.forEach {
            $0.registerCell(in: view)
        }

        self.sections.insert(header, at: sectionIndex)
        self.generators.insert(generators, at: sectionIndex)

        let indexPaths = generators.enumerated().map { IndexPath(row: $0.offset, section: sectionIndex) }

        modifier?.insertSectionsAndRows(at: [sectionIndex: indexPaths], with: animation.value)
    }

}
