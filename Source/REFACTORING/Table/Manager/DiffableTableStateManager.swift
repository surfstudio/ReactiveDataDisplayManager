//
//  DiffableTableStateManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import Foundation

public protocol Diffable {
    var item: DiffableItem { get }
}

@available(iOS 13.0, *)
public class DiffableTableManager: BaseTableManager {

    // MARK: - Typealias

    public typealias CellGeneratorType = TableCellGenerator & Diffable
    public typealias HeaderGeneratorType = TableHeaderGenerator & Diffable

    // MARK: - Constants

    private enum Constants {
        static let emptySectionId = "RDDM.Diffable.EmptySection"
    }

    // MARK: - Private Properties

    private var snapshot = DiffableSnapshot()

    // MARK: - Public Methods

    open override func addCellGenerator(_ generator: TableCellGenerator) {
        assert(generator is CellGeneratorType, "This strategy support only \(CellGeneratorType.Type.self)")

        guard
            let generator = generator as? CellGeneratorType,
            let view = view
        else {
            return
        }

        generator.registerCell(in: view)

        addEmptyGeneratorsIfNeeded()

        let index = sections.count - 1
        let currentIndex = index < 0 ? 0 : index
        generators[currentIndex].append(generator)

        appendGenerators([generator])
    }

    open override func addCellGenerators(_ generators: [TableCellGenerator]) {
        generators.forEach { addCellGenerator($0) }
    }

    open override func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        addCellGenerators([generator], after: after)
    }

    open override func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        assert(generators is [CellGeneratorType], "This strategy support only \(CellGeneratorType.Type.self)")
        assert(after is CellGeneratorType, "This strategy support only \(CellGeneratorType.Type.self)")

        guard
            let view = view,
            let generators = generators as? [CellGeneratorType],
            let after = after as? CellGeneratorType
        else {
            return
        }

        generators.forEach { $0.registerCell(in: view) }

        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            fatalError("Error adding TableCellGenerator generator. You tried to add generators after unexisted generator")
        }

        self.generators[sectionIndex].insert(contentsOf: generators, at: generatorIndex + 1)
        insertGenerators(generators, after: after)
    }

    open func addSectionHeaderGenerator(_ generator: HeaderGeneratorType) {
        sections.append(generator)
        addEmptyGeneratorsIfNeeded()

        addedSection(with: generator)
    }

    open func addCellGenerator(_ generator: CellGeneratorType, toHeader header: HeaderGeneratorType) {
        addCellGenerators([generator], toHeader: header)
    }

    open func addCellGenerators(_ generators: [CellGeneratorType], toHeader header: HeaderGeneratorType) {
        guard let view = view else { return }

        generators.forEach { $0.registerCell(in: view) }

        addEmptyGeneratorsIfNeeded()

        guard let index = sections.firstIndex(where: { $0 === header }) else { return }

        self.generators[index].append(contentsOf: generators)
        appendGenerators(generators, to: header)
    }

    open func removeAllGenerators(from header: HeaderGeneratorType) {
        guard
            let index = sections.index(where: { $0 === header }),
            generators.count > index
        else {
            return
        }

        generators[index].removeAll()
        snapshot.deleteSections([header.item])
    }

    open override func clearCellGenerators() {
        generators.removeAll()
        snapshot.deleteAllItems()
    }

    open func clearHeaderGenerators() {
        sections.removeAll()

        let sectionIdentifiers = snapshot.sectionIdentifiers
        snapshot.deleteSections(sectionIdentifiers)
    }

    open func replace(oldGenerator: CellGeneratorType,
                      on newGenerator: CellGeneratorType,
                      animated: Bool = false) {
        guard let index = findGenerator(oldGenerator) else { return }

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        generators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)

        snapshot.insertItems([newGenerator.item], afterItem: oldGenerator.item)
        snapshot.deleteItems([oldGenerator.item])

        safeApplySnapshot(animated: animated)
    }

    open func remove(_ generator: CellGeneratorType,
                     animated: Bool = true,
                     needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                     needRemoveEmptySection: Bool = false) {
        guard
            let index = findGenerator(generator),
            let view = view
        else {
            return
        }

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
        snapshot.deleteItems([generator.item])

        // remove empty section if needed
        if needRemoveEmptySection && generators[index.sectionIndex].isEmpty, let section = sections[index.sectionIndex] as? HeaderGeneratorType {
            generators.remove(at: index.sectionIndex)
            snapshot.deleteSections([section.item])
            sections.remove(at: index.sectionIndex)
        }

        // scroll if needed
        if let scrollPosition = scrollPosition {
            view.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }

        safeApplySnapshot(animated: animated)
    }

    open override func update(generators: [TableCellGenerator]) {
        guard let generators = generators as? [CellGeneratorType] else { return }
        let items = generators.map { $0.item }
        snapshot.reloadItems(items)
        safeApplySnapshot()
    }

    open func apply() {
        safeApplySnapshot()
    }

}

@available(iOS 13.0, *)
private extension DiffableTableManager {

    func insertGenerators(_ generators: [CellGeneratorType], after: CellGeneratorType) {
        let items = generators.map { $0.item }
        snapshot.insertItems(items, afterItem: after.item)
    }

    func appendGenerators(_ generators: [CellGeneratorType], to section: HeaderGeneratorType? = nil) {
        addedSection(with: section)

        let items = generators.map { $0.item }
        snapshot.appendItems(items, toSection: section?.item)
    }

    func addedSection(with section: HeaderGeneratorType?) {
        addEmptySectionIfNeeded(with: section)

        guard let section = section, snapshot.indexOfSection(section.item) == nil else { return }
        snapshot.appendSections([section.item])
    }

    func addEmptySectionIfNeeded(with section: HeaderGeneratorType?) {
        guard snapshot.numberOfSections == .zero, section == nil else { return }
        let sectionItem = DiffableItem(identifier: Constants.emptySectionId)
        snapshot.appendSections([sectionItem])

        guard sections.isEmpty else { return }
        sections.append(EmptyTableHeaderGenerator())
    }

    func addEmptyGeneratorsIfNeeded() {
        guard generators.count != sections.count || sections.isEmpty else { return }
        generators.append([CellGeneratorType]())
    }

    func safeApplySnapshot(animated: Bool = false) {
        DispatchQueue.main.async {
            (self.dataSource as? DiffableTableDataSource)?.apply(self.snapshot, animatingDifferences: animated)
        }
    }

}
