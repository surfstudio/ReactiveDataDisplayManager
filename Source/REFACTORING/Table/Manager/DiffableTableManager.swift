//
//  DiffableTableManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol Diffable {
    var item: DiffableItem { get }
}

extension EmptyTableHeaderGenerator: Diffable {

    public var item: DiffableItem {
        .init(identifier: "RDDM.Diffable.EmptySection")
    }

}

@available(iOS 13.0, *)
public class DiffableTableStateManager: BaseTableManager {

    // MARK: - Typealias

    public typealias CellGeneratorType = TableCellGenerator & Diffable
    public typealias HeaderGeneratorType = TableHeaderGenerator & Diffable

    // MARK: - Private Methods

    private var diffableDataSource: DiffableTableDataSource? {
        dataSource as? DiffableTableDataSource
    }

    // MARK: - Public Methods

    open func addSectionHeaderGenerator(_ generator: HeaderGeneratorType) {
        sections.append(generator)
    }

    open func addCellGenerator(_ generator: CellGeneratorType, toHeader header: HeaderGeneratorType) {
        addCellGenerators([generator], toHeader: header)
    }

    open func addCellGenerators(_ generators: [CellGeneratorType], toHeader header: HeaderGeneratorType) {
        generators.forEach { $0.registerCell(in: view) }

        guard let index = sections.firstIndex(where: { $0 === header }) else { return }

        self.generators[index].append(contentsOf: generators)
    }

    open func removeAllGenerators(from header: HeaderGeneratorType) {
        guard
            let index = sections.firstIndex(where: { $0 === header }),
            generators.count > index
        else {
            return
        }
        
        generators[index].removeAll()
    }

    open func clearHeaderGenerators() {
        sections.removeAll()
    }

    open func replace(oldGenerator: CellGeneratorType,
                      on newGenerator: CellGeneratorType,
                      animated: Bool = false) {
        guard let index = findGenerator(oldGenerator) else { return }

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        generators[index.sectionIndex].insert(newGenerator, at: index.generatorIndex)

        apply(animated: animated)
    }

    open func remove(_ generator: CellGeneratorType,
                     animated: Bool = true,
                     needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                     needRemoveEmptySection: Bool = false,
                     completion: (() -> Void)? = nil) {
        guard
            let index = findGenerator(generator)
        else {
            return
        }

        generators[index.sectionIndex].remove(at: index.generatorIndex)

        // remove empty section if needed
        if needRemoveEmptySection && generators[index.sectionIndex].isEmpty {
            generators.remove(at: index.sectionIndex)
            sections.remove(at: index.sectionIndex)
        }

        // scroll if needed
        if let scrollPosition = scrollPosition {
            let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)
            view.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }

        apply(animated: animated, completion: completion)
    }

    open override func update(generators: [TableCellGenerator]) {
        guard
            let generators = generators as? [CellGeneratorType],
            var snapshot = diffableDataSource?.snapshot()
        else { return }

        let items = generators.map { $0.item }
        snapshot.reloadItems(items)

        safeApplySnapshot(snapshot)
    }

    open func apply(animated: Bool = false, completion: (() -> Void)? = nil) {
        let snapshot = makeSnapshot()
        safeApplySnapshot(snapshot, animated: animated, completion: completion)
    }

}

@available(iOS 13.0, *)
private extension DiffableTableStateManager {

    func addEmptySectionIfNeeded() {
        guard sections.isEmpty else { return }
        sections.append(EmptyTableHeaderGenerator())
    }

    func addEmptyGeneratorsIfNeeded() {
        guard generators.count != sections.count || sections.isEmpty else { return }
        generators.append([CellGeneratorType]())
    }

    func makeSnapshot() -> DiffableSnapshot? {
        assert(generators is [[CellGeneratorType]], "This strategy support only \(CellGeneratorType.Type.self)")
        assert(sections is [HeaderGeneratorType], "This strategy support only \(CellGeneratorType.Type.self)")

        guard
            let sections = sections as? [HeaderGeneratorType],
            let generators = generators as? [[CellGeneratorType]]
        else { return nil }

        var snapshot = DiffableSnapshot()

        for (index, section) in sections.enumerated() {
            snapshot.appendSections([section.item])

            guard let generators = generators[safe: index] else { continue }

            let items = generators.map { $0.item }
            snapshot.appendItems(items, toSection: section.item)
        }

        return snapshot
    }

    func safeApplySnapshot(_ snapshot: DiffableSnapshot?, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let snapshot = snapshot else { return }

        DispatchQueue.main.async {
            self.diffableDataSource?.apply(snapshot, animatingDifferences: animated, completion: completion)
        }
    }

}
