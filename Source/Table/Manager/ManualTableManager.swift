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

    /// Adds section TableHeaderGenerator generator  to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for new section TableHeaderGenerator.
    open func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
        self.sections.append(generator)
    }

    /// Inserts new TableHeaderGenerator generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - after: TableHeaderGenerator, after which new TableHeaderGenerator will be added.
    open func insert(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === after }) else {
            fatalError("Error adding TableHeaderGenerator generator. You tried to add generators after unexisted generator")
        }
        let newIndex = anchorIndex + 1
        self.insert(headGenerator: headGenerator, by: newIndex)
    }

    /// Inserts new TableHeaderGenerator generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - after: TableHeaderGenerator, before which new TableHeaderGenerator will be added.
    open func insert(headGenerator: TableHeaderGenerator, before: TableHeaderGenerator) {
        if self.sections.contains(where: { $0 === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0 === before }) else {
            fatalError("Error adding TableHeaderGenerator generator. You tried to add generators after unexisted generator")
        }
        let newIndex = max(anchorIndex - 1, 0)
        self.insert(headGenerator: headGenerator, by: newIndex)
    }

    /// Removes all headers generators
    open func clearHeaderGenerators() {
        self.sections.removeAll()
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
        dataSource?.modifier?.reloadSections(at: [index], with: animation)
    }

    /// Inserts new generators to provided TableHeaderGenerator generator.
    ///
    /// - Parameters:
    ///   - generators: Generators to insert
    ///   - TableHeaderGenerator: TableHeaderGenerator generator in which you want to insert.
    open func addCellGenerators(_ generators: [TableCellGenerator], toHeader headerGenerator: TableHeaderGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([TableCellGenerator]())
        }

        if let index = self.sections.firstIndex(where: { $0 === headerGenerator }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    /// Removes all TableCellGenerator generators from a given section
    open func removeAllGenerators(from headerGenerator: TableHeaderGenerator) {
        guard let index = self.sections.firstIndex(where: { $0 === headerGenerator }), self.generators.count > index else {
            return
        }

        self.generators[index].removeAll()
    }

    open func addCellGenerator(_ generator: TableCellGenerator, toHeader headerGenerator: TableHeaderGenerator) {
        addCellGenerators([generator], toHeader: headerGenerator)
    }

    /// Inserts new head generator.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - by: Index which new TableHeaderGenerator will be added.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insert(headGenerator: TableHeaderGenerator,
                     by index: Int,
                     generators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: headGenerator, by: index, animation: animation)
        guard let headerIndex = self.sections.firstIndex(where: { $0 === headGenerator }) else {
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
    ///   - before: TableHeaderGenerator before which new section will be added.
    ///   - new: TableHeaderGenerator which you want to insert before current TableHeaderGenerator.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(before headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: sectionHeader, before: headerGenerator)

        guard let headerIndex = self.sections.firstIndex(where: {
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
    ///   - after: TableHeaderGenerator after which new section will be added.
    ///   - new: TableHeaderGenerator which you want to insert after current TableHeaderGenerator.
    ///   - generators: Generators which you want to insert.
    ///   - with: Animation for row action.
    open func insertSection(after headerGenerator: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.insert(headGenerator: sectionHeader, after: headerGenerator)

        guard let headerIndex = self.sections.firstIndex(where: {
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

    /// Inserts new generator before provided TableHeaderGenerator.
    ///
    /// - Parameters:
    ///   - to: TableHeaderGenerator before which new generator will be added. Must be in the DDM.
    ///   - new: Generator which you want to insert after current generator.
    ///   - with: Animation for row action.
    open func insert(to headerGenerator: TableHeaderGenerator,
                     new generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
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
                                with animation: UITableView.RowAnimation = .automatic) {
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
                          with animation: UITableView.RowAnimation = .automatic) {
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
    ///   - removeAnimation: Animation for remove action.
    ///   - insertAnimation: Animation for insert action.
    open func replace(oldGenerator: TableCellGenerator,
                      on newGenerator: TableCellGenerator,
                      removeAnimation: UITableView.RowAnimation = .automatic,
                      insertAnimation: UITableView.RowAnimation = .automatic) {
        guard let index = self.findGenerator(oldGenerator) else { return }

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        generators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        dataSource?.modifier?.replace(at: indexPath, with: removeAnimation, and: insertAnimation)
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

        dataSource?.modifier?.reload()
    }

}

// MARK: - Private

private extension ManualTableManager {

    // MARK: - Private methods

    func insert(headGenerator: TableHeaderGenerator,
                by index: Int,
                animation: UITableView.RowAnimation = .none) {
        let index = min(max(index, 0), self.sections.count)
        self.sections.insert(headGenerator, at: index)
        self.generators.insert([], at: index)

        dataSource?.modifier?.insertSections(at: [index], with: animation)
    }

    func insert(elements: [(generator: TableCellGenerator, sectionIndex: Int, generatorIndex: Int)],
                with animation: UITableView.RowAnimation = .automatic) {

        elements.forEach { [weak self] element in
            element.generator.registerCell(in: view)
            self?.generators[element.sectionIndex].insert(element.generator, at: element.generatorIndex)
        }

        let indexPaths = elements.map {
            IndexPath(row: $0.generatorIndex, section: $0.sectionIndex)
        }

        dataSource?.modifier?.insertRows(at: indexPaths, with: animation)
    }

}
