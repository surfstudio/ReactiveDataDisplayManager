//
//  BaseDataDisplayManager.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Contains base implementation of TableDataManager and TableDisplayManager.
/// Can register nib if needed, determinate EstimatedRowHeight.
/// Can fill table with user data.
public class BaseTableDataDisplayManager: NSObject, TableDataDisplayManager {

    // MARK: - Events

    /// Called if table scrolled
    public var scrollEvent = BaseEvent<UITableView>()

    // MARK: - Fileprivate properties

    fileprivate var cellGenerators: [TableCellGenerator]
    fileprivate var sectionHeaderGenerator: [ViewGenerator]
    fileprivate weak var tableView: UITableView?
    fileprivate let estimatedHeight: CGFloat

    // MARK: - Initialization and deinitialization

    public init(estimatedHeight: CGFloat = 40) {
        self.estimatedHeight = estimatedHeight
        self.cellGenerators = [TableCellGenerator]()
        self.sectionHeaderGenerator = [ViewGenerator]()
        super.init()
    }

    /// Set TableView to current adapter.
    ///
    /// - Parameter tableView: new TableView
    public func setTableView(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
}

// MRK: - Generator actions

public extension BaseTableDataDisplayManager {

    /// Added new header for section generator.
    ///
    /// - Parameter generator: new generator.
    public func addSectionHeaderGenerator(_ generator: ViewGenerator) {
        self.sectionHeaderGenerator.append(generator)
    }

    /// Added new cell generator.
    ///
    /// - Parameters:
    ///   - generator: New cell generator.
    ///   - needRegister: flag, that describe needed register generator nib.
    public func addCellGenerator(_ generator: TableCellGenerator, needRegister: Bool = true) {
        if needRegister {
            self.tableView?.registerNib(generator.identifier)
        }
        self.cellGenerators.append(generator)
    }

    /// Remove all cell generators.
    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    /// Remove all header generators.
    public func clearHeaderGenerators() {
        self.sectionHeaderGenerator.removeAll()
    }

    /// Calling if generators did removed and added again
    public func didRefill() {
        self.tableView?.reloadData()
    }
}

// MARK: - TableView actions

public extension BaseTableDataDisplayManager {

    /// Remove generator from adapter. Generators compare by references.
    ///
    /// - Parameters:
    ///   - generator: Generator to delete.
    ///   - animation: Animation for row action.
    public func remove(_ generator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.cellGenerators.index(where: { $0 === generator }) else { return }
        self.removeGenerator(with: index, with: animation)
    }

    /// Insert new generator after current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert after current generator.
    ///   - animation: Animation for row action.
    public func insert(after generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.cellGenerators.index(where: { $0 === generator }) else { return }

        self.insertGenerator(newGenerator, at: index + 1, with: animation)
    }

    /// Insert new generator before current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert before current generator.
    ///   - animation: Animation for row action.
    public func insert(before generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.cellGenerators.index(where: { $0 === generator }) else { return }

        self.insertGenerator(newGenerator, at: index - 1, with: animation)
    }

    /// Swap two adapter betwwen each other.
    /// Warning!!! Call reload data in tableView.
    ///
    /// - Parameters:
    ///   - firstGenerator: Generator which must to move to new place. Must contins in adapter.
    ///   - secondGenerator: Generator which must to replaced with firstGenerator and move to it place. Must contains id adapter.
    public func swap(firstGenerator: TableCellGenerator, with secondGenerator: TableCellGenerator) {
        guard let firstIndex = self.cellGenerators.index(where: { $0 === firstGenerator }),
            let secondIndex = self.cellGenerators.index(where: { $0 === secondGenerator })
        else { return }

        self.cellGenerators.remove(at: firstIndex)
        self.cellGenerators.remove(at: secondIndex)

        self.cellGenerators.insert(firstGenerator, at: secondIndex)
        self.cellGenerators.insert(secondGenerator, at: firstIndex)

        self.tableView?.reloadData()
    }
}

// MARK: - Private methods

private extension BaseTableDataDisplayManager {

    func insertGenerator(_ generator: TableCellGenerator, at index: Int, with animation: UITableViewRowAnimation = .automatic) {

        guard let table = self.tableView else { return }

        table.registerNib(generator.identifier)
        table.beginUpdates()
        self.cellGenerators.insert(generator, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        table.insertRows(at: [indexPath], with: animation)
        table.endUpdates()
    }

    func removeGenerator(with index: Int, with animation: UITableViewRowAnimation = .automatic) {

        guard let table = self.tableView else { return }

        table.beginUpdates()
        self.cellGenerators.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        table.deleteRows(at: [indexPath], with: animation)
        table.endUpdates()
    }

}

// MARK: - UITableViewDelegate

extension BaseTableDataDisplayManager: UITableViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let guardTable = self.tableView else { return }
        self.scrollEvent.invoke(with: guardTable)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.estimatedHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectable = self.cellGenerators[indexPath.row] as? SelectableItem else { return }
        selectable.didSelectEvent.invoke(with: ())
    }
}

// MARK: - UITableViewDataSource

extension BaseTableDataDisplayManager: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > self.sectionHeaderGenerator.count - 1 {
            return nil
        }

        return self.sectionHeaderGenerator[section].generate()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellGenerators.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellGenerators[indexPath.row].generate(tableView: tableView, for: indexPath)
    }
}
