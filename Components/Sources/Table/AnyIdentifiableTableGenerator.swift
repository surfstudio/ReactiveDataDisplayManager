//
//  AnyIdentifiableTableGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 24.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

public final class AnyIdentifiableTableCellGenerator: TableCellGenerator, DiffableItemSource {

    public typealias IdentifiableGenerator = TableCellGenerator & DiffableItemSource

    private let wrappedValue: IdentifiableGenerator

    // MARK: - RegisterableItem

    public var descriptor: String {
        wrappedValue.descriptor
    }

    // MARK: - DiffableItemSource

    public var identifier: String {
        wrappedValue.identifier
    }

    public var diffableItem: DiffableItem {
        wrappedValue.diffableItem
    }

    // MARK: - Initialisations

    public init(generator: IdentifiableGenerator) {
        self.wrappedValue = generator
    }

    public init?(identifiable: DiffableItemSource) {
        guard let generator = identifiable as? IdentifiableGenerator else {
            return nil
        }
        self.wrappedValue = generator
    }

    // MARK: - Generator

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        wrappedValue.generate(tableView: tableView, for: indexPath)
    }

    public func registerCell(in tableView: UITableView) {
        wrappedValue.registerCell(in: tableView)
    }

}
