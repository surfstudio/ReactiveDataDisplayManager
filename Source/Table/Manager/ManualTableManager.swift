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
    ///   - generator: Generator for new section TableHeaderGenerator, TableFooterGenerator (default value EmptyTableFooterGenerator).
    ///   - cells: Generators for this section.
    open func addSection(TableHeaderGenerator generator: TableHeaderGenerator,
                         footerGenerator: TableFooterGenerator = EmptyTableFooterGenerator(),
                         cells: [TableCellGenerator]) {
        addTableGenerators(with: cells, choice: .newSection(header: generator, footer: footerGenerator))
    }

    /// Adds section TableHeaderGenerator generator  to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for new section TableHeaderGenerator.
    open func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
        addHeader(header: generator)
    }

    /// Adds section TableFooterGenerator generator  to the end of collection
    ///
    /// - Parameters:
    ///   - generator: Generator for current section TableFooterGenerator.
    open func addSectionFooterGenerator(_ generator: TableFooterGenerator) {
        addFooter(footer: generator)
    }

    /// Inserts new TableHeaderGenerator generator after another.
    ///
    /// - Parameters:
    ///   - headGenerator: TableHeaderGenerator which you want to insert.
    ///   - after: TableHeaderGenerator, after which new TableHeaderGenerator will be added.
    open func insert(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) {
        if self.sections.contains(where: { $0.header === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0.header === after }) else {
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
        if self.sections.contains(where: { $0.header === headGenerator }) {
            fatalError("Error adding TableHeaderGenerator generator. TableHeaderGenerator generator was added earlier")
        }
        guard let anchorIndex = self.sections.firstIndex(where: { $0.header === before }) else {
            fatalError("Error adding TableHeaderGenerator generator. You tried to add generators after unexisted generator")
        }
        let newIndex = max(anchorIndex - 1, 0)
        self.insert(headGenerator: headGenerator, by: newIndex)
    }

    /// Reloads only one section with specified animation
    ///
    /// - Parameters:
    ///   - sectionHeaderGenerator: TableHeaderGenerator of section which you want to reload.
    ///   - animation: Type of reload animation
    open func reloadSection(by sectionHeaderGenerator: TableHeaderGenerator, with animation: UITableView.RowAnimation = .none) {
        sections.registerAllIfNeeded(with: view, using: registrator)
        if let index = sections.firstIndex(where: { $0.header === sectionHeaderGenerator }) {
            modifier?.reloadSections(at: [index], with: animation)
        }
    }

    /// Inserts new generators to provided TableHeaderGenerator generator.
    ///
    /// - Parameters:
    ///   - generators: Generators to insert
    ///   - TableHeaderGenerator: TableHeaderGenerator generator in which you want to insert.
    open func addCellGenerators(_ generators: [TableCellGenerator], toHeader headerGenerator: TableHeaderGenerator) {

        if let index = sections.firstIndex(where: { $0.header === headerGenerator }) {
            addTableGenerators(with: generators, choice: .byIndex(index))
        }
    }

    /// Removes all TableCellGenerator generators from a given section
    open func removeAllGenerators(from headerGenerator: TableHeaderGenerator) {
        guard let index = self.sections.firstIndex(where: { $0.header === headerGenerator }),
              self.sections.count > index else {
            return
        }

        let generatorsCount = sections[index].generators.count

        self.sections[index].generators.removeAll()

        let indexes = (0..<generatorsCount).map { IndexPath(row: $0, section: index) }

        guard !indexes.isEmpty else {
            return
        }

        modifier?.removeRows(at: indexes, and: nil, with: .automatic)
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
        guard let headerIndex = self.sections.firstIndex(where: { $0.header === headGenerator }) else {
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
            $0.header === sectionHeader
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
            $0.header === sectionHeader
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
        guard let headerIndex = self.sections.firstIndex(where: { $0.header === headerGenerator }) else {
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
        guard let headerIndex = self.sections.firstIndex(where: { $0.header === headerGenerator }) else {
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
        guard let headerIndex = self.sections.firstIndex(where: { $0.header === headerGenerator }) else {
            return
        }
        let base = self.sections[headerIndex].generators.count
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

        sections[index.sectionIndex].generators.remove(at: index.generatorIndex)
        sections[index.sectionIndex].generators.insert(newGenerator, at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        sections.registerAllIfNeeded(with: view, using: registrator)
        modifier?.replace(at: indexPath, with: (remove: removeAnimation, insert: insertAnimation))
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

        sections[firstIndex.sectionIndex].generators.remove(at: firstIndex.generatorIndex)
        sections[secondIndex.sectionIndex].generators.remove(at: secondIndex.generatorIndex)

        sections[secondIndex.sectionIndex].generators.insert(firstGenerator, at: secondIndex.generatorIndex)
        sections[firstIndex.sectionIndex].generators.insert(secondGenerator, at: firstIndex.generatorIndex)

        sections.registerAllIfNeeded(with: view, using: registrator)
        modifier?.reload()
    }

}

// MARK: - Private

private extension ManualTableManager {

    // MARK: - Private methods

    func insert(headGenerator: TableHeaderGenerator,
                by index: Int,
                animation: UITableView.RowAnimation = .none) {
        let index = min(max(index, 0), self.sections.count)
        self.sections.insert(.init(generators: [],
                                   header: headGenerator,
                                   footer: EmptyTableFooterGenerator()), at: index)

        sections.registerAllIfNeeded(with: view, using: registrator)
        modifier?.insertSections(at: [index], with: animation)
    }

}
