//
//  HeaderableTableDataDisplayManager.swift
//  GoLamaGo
//
//  Created by Ivan Smetanin on 20/09/2017.
//  Copyright © 2017 Surf. All rights reserved.
//

import Foundation

/// Protocol for work with cell.
public protocol HeaderableTableDataDisplayManager: class {

    /// Adds the new header generator.
    func addSectionHeaderGenerator(_ generator: HeaderGenerator)

    /// Adds the new cell generator.
    ///
    /// - Parameters:
    ///   - generator: Generator which should be added.
    ///   - header: Header in which is added to generator, if nil generator
    /// will be added to the last header.
    ///   - needRegister: Pass true to register the cell nib.
    func addCellGenerator(_ generator: TableCellGenerator, toHeader header: HeaderGenerator?, needRegister: Bool)

    /// Sets tableView for current manager
    func setTableView(_ tableView: UITableView)
}

public class BaseHeaderableTableDataDisplayManager: NSObject, HeaderableTableDataDisplayManager {

    // MARK: - Events

    /// Calls if table scrolled
    public var scrollEvent = BaseEvent<UITableView>()

    // MARK: - Constants

    fileprivate let estimatedHeight: CGFloat

    // MARK: - Fileprivate properties

    fileprivate var cellGenerators: [[TableCellGenerator]]
    fileprivate var sectionHeaderGenerators: [HeaderGenerator]
    fileprivate weak var tableView: UITableView?

    // MARK: - Initialization and deinitialization

    public init(estimatedHeight: CGFloat = 40) {
        self.estimatedHeight = estimatedHeight
        self.cellGenerators = [[TableCellGenerator]]()
        self.sectionHeaderGenerators = [HeaderGenerator]()
        super.init()
    }

    /// Sets UITableView to current adapter.
    ///
    /// - Parameter tableView: new UITableView
    public func setTableView(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
}

// MRK: - Generator actions

public extension BaseHeaderableTableDataDisplayManager {

    /// Adds the new header section generator.
    ///
    /// - Parameter generator: new generator.
    public func addSectionHeaderGenerator(_ generator: HeaderGenerator) {
        self.sectionHeaderGenerators.append(generator)
    }

    /// Removes generator from adapter. Generators compare by references.
    ///
    /// - Parameters:
    ///   - generator: Generator to delete.
    ///   - animation: Animation for row action.
    public func remove(_ generator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }
        self.removeGenerator(with: index, with: animation)
    }


    /// Added new cell generator to current header.
    /// If header is nil, then generator will be added to last contained header
    ///
    /// - Parameters:
    ///   - generator: New Generator
    ///   - header: Header for adding generator
    ///   - needRegister: needs register Generator view as nib
    public func addCellGenerator(_ generator: TableCellGenerator, toHeader header: HeaderGenerator? = nil, needRegister: Bool = true) {
        if needRegister {
            self.tableView?.registerNib(generator.identifier)
        }
        if self.cellGenerators.count != self.sectionHeaderGenerators.count || sectionHeaderGenerators.isEmpty {
            self.cellGenerators.append([TableCellGenerator]())
        }

        if let header = header {
            if let index = self.sectionHeaderGenerators.index(where: { $0 === header }) {
                self.cellGenerators[index].append(generator)
            }
        } else if sectionHeaderGenerators.isEmpty {
            fatalError("You try to add generator to Headerable manager without HeaderGenerators (Headers count = 0)")
        } else {
            self.cellGenerators[sectionHeaderGenerators.count - 1].append(generator)
        }
    }

    /// Inserts new generator after current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert after current generator.
    ///   - animation: Animation for row action.
    public func insert(after generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic, needScrollAt scrollPosition: UITableViewScrollPosition? = nil) {
        guard let index = self.findGenerator(generator) else { return }

        self.insertGenerator(newGenerator, at: (genIndex: index.genIndex + 1, arrIndex: index.arrIndex), with: animation, needScrollAt: scrollPosition)
    }

    public func insert(to header: HeaderGenerator, generator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic, needScrollAt scrollPosition: UITableViewScrollPosition? = nil) {
        guard let headerIndex = self.sectionHeaderGenerators.index(where: {$0 === header}) else { return }

        self.insertGenerator(generator, at: (genIndex: 0, arrIndex: headerIndex), with: animation, needScrollAt: scrollPosition)
    }

    /// Inserts new generator before current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert before current generator.
    ///   - animation: Animation for row action.
    public func insert(before generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic, needScrollAt scrollPosition: UITableViewScrollPosition? = nil) {
        guard let index = self.findGenerator(generator) else { return }

        self.insertGenerator(newGenerator, at: (genIndex: index.genIndex - 1, arrIndex: index.arrIndex), with: animation, needScrollAt: scrollPosition)
    }

    /// Removes all cell generators.
    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    /// Removes all header generators.
    public func clearHeaderGenerators() {
        self.sectionHeaderGenerators.removeAll()
    }

    /// Call this method if generators was removed or added.
    public func didRefill() {
        self.tableView?.reloadData()
    }
}

private extension BaseHeaderableTableDataDisplayManager {

    func findGenerator(_ toFindGenerator: TableCellGenerator) -> (genIndex: Int, arrIndex: Int)? {
        for genIndex in 0..<self.cellGenerators.count {
            if let index = self.cellGenerators[genIndex].index(where: { $0 === toFindGenerator }) {
                return (index, genIndex)
            }
        }
        return nil
    }

    func removeGenerator(with index: (genIndex: Int, arrIndex: Int), with animation: UITableViewRowAnimation = .automatic, needScrollAt scrollPosition: UITableViewScrollPosition? = nil) {
        guard let table = self.tableView else { return }
        
        if index.genIndex > 0 {
            let previousIndexPath = IndexPath(row: index.genIndex - 1, section: index.arrIndex)
            if let scrollPosition = scrollPosition {
                table.scrollToRow(at: previousIndexPath, at: scrollPosition, animated: true)
            }
        }
        table.beginUpdates()
        self.cellGenerators[index.arrIndex].remove(at: index.genIndex)
        let indexPath = IndexPath(row: index.genIndex, section: index.arrIndex)
        table.deleteRows(at: [indexPath], with: animation)
        if self.cellGenerators[index.arrIndex].isEmpty {
            self.cellGenerators.remove(at: index.arrIndex)
            self.sectionHeaderGenerators.remove(at: index.arrIndex)
            table.deleteSections(IndexSet(integer: index.arrIndex), with: animation)
        }

        table.endUpdates()
    }

    func insertGenerator(_ generator: TableCellGenerator, at index: (genIndex: Int, arrIndex: Int), with animation: UITableViewRowAnimation = .automatic, needScrollAt scrollPosition: UITableViewScrollPosition? = nil) {

        guard let table = self.tableView else { return }

        table.registerNib(generator.identifier)
        table.beginUpdates()
        self.cellGenerators[index.arrIndex].insert(generator, at: index.genIndex)
        let indexPath = IndexPath(row: index.genIndex, section: index.arrIndex)
        table.insertRows(at: [indexPath], with: animation)
        table.endUpdates()
        if let scrollPosition = scrollPosition {
            table.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        }
    }
}

extension BaseHeaderableTableDataDisplayManager {
    public func insert(header: HeaderGenerator, after: HeaderGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let headerIndex = self.sectionHeaderGenerators.index(where: {$0 === header}) else { return }

        guard let table = self.tableView else { return }

        table.beginUpdates()
        self.sectionHeaderGenerators.insert(header, at: headerIndex + 1)
        table.insertSections(IndexSet(integer: headerIndex + 1), with: animation)
        table.endUpdates()
    }
}

// MARK: - UITableViewDelegate

extension BaseHeaderableTableDataDisplayManager: UITableViewDelegate {

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

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > self.sectionHeaderGenerators.count - 1 {
            return nil
        }
        return self.sectionHeaderGenerators[section].generate()
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // This code needed to avoid empty header
        if section > sectionHeaderGenerators.count - 1 {
            return 0.01
        }
        return self.sectionHeaderGenerators[section].height(tableView, forSection: section)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectable = cellGenerators[indexPath.section][indexPath.row] as? SelectableItem else { return }
        selectable.didSelectEvent.invoke(with: ())
        if selectable.isNeedDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension BaseHeaderableTableDataDisplayManager: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderGenerators.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellGenerators[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellGenerators[indexPath.section][indexPath.row].generate(tableView: tableView, for: indexPath)
    }
}
