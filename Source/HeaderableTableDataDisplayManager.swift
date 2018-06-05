//
//  HeaderableTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 20/09/2017.
//

import Foundation

/// Protocol for work with cell.
public protocol HeaderableTableDataDisplayManager: class {

    /// Adds the new header generator.
    func addSectionHeaderGenerator(_ generator: TableHeaderGenerator)

    /// Adds the new cell generator.
    ///
    /// - Parameters:
    ///   - generator: Generator which should be added.
    ///   - header: Header in which is added to generator, if nil generator
    /// will be added to the last header.
    ///   - needRegister: Pass true to register the cell nib.
    func addCellGenerator(_ generator: TableCellGenerator, toHeader header: TableHeaderGenerator?, needRegister: Bool)

    /// Sets tableView for current manager
    func setTableView(_ tableView: UITableView)
}

open class BaseHeaderableTableDataDisplayManager: NSObject, HeaderableTableDataDisplayManager {

    // MARK: - Events

    /// Calls if table scrolled
    public var scrollEvent = BaseEvent<UITableView>()

    // MARK: - Constants

    fileprivate let estimatedHeight: CGFloat

    // MARK: - Fileprivate properties

    public fileprivate(set) var cellGenerators: [[TableCellGenerator]]
    public fileprivate(set) var sectionHeaderGenerators: [TableHeaderGenerator]
    fileprivate weak var tableView: UITableView?

    // MARK: - Initialization and deinitialization

    public init(estimatedHeight: CGFloat = 40) {
        self.estimatedHeight = estimatedHeight
        self.cellGenerators = [[TableCellGenerator]]()
        self.sectionHeaderGenerators = [TableHeaderGenerator]()
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
    public func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
        self.sectionHeaderGenerators.append(generator)
        self.cellGenerators.append([])
    }

    /// Removes generator from adapter. Generators compare by references.
    ///
    /// - Parameters:
    ///   - generator: Generator to delete.
    ///   - animation: Animation for row action.
    public func remove(_ generator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic, needRemoveEmptySection: Bool = false) {
        guard let index = self.findGenerator(generator) else { return }
        self.removeGenerator(with: index, with: animation, needRemoveEmptySection: needRemoveEmptySection)
    }

    private func findGenerator(_ toFindGenerator: TableCellGenerator) -> (genIndex: Int, arrIndex: Int)? {
        for genIndex in 0..<self.cellGenerators.count {
            if let index = self.cellGenerators[genIndex].index(where: { $0 === toFindGenerator }) {
                return (index, genIndex)
            }
        }
        return nil
    }

    func removeGenerator(with index: (genIndex: Int, arrIndex: Int), with animation: UITableViewRowAnimation = .automatic, needRemoveEmptySection: Bool = false) {
        guard let table = self.tableView else { return }

        table.beginUpdates()
        self.cellGenerators[index.arrIndex].remove(at: index.genIndex)
        let indexPath = IndexPath(row: index.genIndex, section: index.arrIndex)
        table.deleteRows(at: [indexPath], with: animation)
        if needRemoveEmptySection && self.cellGenerators[index.arrIndex].isEmpty {
            self.cellGenerators.remove(at: index.arrIndex)
            self.sectionHeaderGenerators.remove(at: index.arrIndex)
            table.deleteSections(IndexSet(integer: index.arrIndex), with: animation)
        }
        table.endUpdates()
    }

    public func addCellGenerator(_ generator: TableCellGenerator, toHeader header: TableHeaderGenerator? = nil, needRegister: Bool = true) {
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
        } else {
            // Add to last section
            // FIXME: crashes if there is not sectionHeaderGenerators
            let index = sectionHeaderGenerators.count - 1
            self.cellGenerators[index < 0 ? 0 : index].append(generator)
        }
    }

    /// Inserts new generator after current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert after current generator.
    ///   - animation: Animation for row action.
    public func insert(after generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }

        self.insertGenerator(newGenerator, at: (genIndex: index.genIndex + 1, arrIndex: index.arrIndex), with: animation)
    }

    public func insert(header: TableHeaderGenerator, after: TableHeaderGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let headerIndex = self.sectionHeaderGenerators.index(where: { $0 === header }) else { return }

        guard let table = self.tableView else { return }

        table.beginUpdates()
        self.sectionHeaderGenerators.insert(header, at: headerIndex + 1)
        table.insertSections(IndexSet(integer: headerIndex + 1), with: animation)
        table.endUpdates()
    }

    public func insert(to header: TableHeaderGenerator, generator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let headerIndex = self.sectionHeaderGenerators.index(where: { $0 === header }) else { return }

        self.insertGenerator(generator, at: (genIndex: 0, arrIndex: headerIndex), with: animation)
    }

    /// Inserts new generator before current generator.
    ///
    /// - Parameters:
    ///   - generator: Current generator. Must contained this adapter.
    ///   - newGenerator: Generator wihics you wont to insert before current generator.
    ///   - animation: Animation for row action.
    public func insert(before generator: TableCellGenerator, new newGenerator: TableCellGenerator, with animation: UITableViewRowAnimation = .automatic) {
        guard let index = self.findGenerator(generator) else { return }

        self.insertGenerator(newGenerator, at: (genIndex: index.genIndex - 1, arrIndex: index.arrIndex), with: animation)
    }

    func insertGenerator(_ generator: TableCellGenerator, at index: (genIndex: Int, arrIndex: Int), with animation: UITableViewRowAnimation = .automatic) {

        guard let table = self.tableView else { return }

        table.registerNib(generator.identifier)
        table.beginUpdates()
        self.cellGenerators[index.arrIndex].insert(generator, at: index.genIndex)
        let indexPath = IndexPath(row: index.genIndex, section: index.arrIndex)
        table.insertRows(at: [indexPath], with: animation)
        table.endUpdates()
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

    /// Updates generators
    ///
    /// - Parameter generators: generators to update
    public func update(generators: [TableCellGenerator]) {
        let indexes = generators.compactMap { [weak self] in  self?.findGenerator($0) }
        let indexPaths = indexes.compactMap { IndexPath(row: $0.genIndex, section: $0.arrIndex) }
        self.tableView?.reloadRows(at: indexPaths, with: .none)
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

open class PaginableHeaderableTableDataDisplayManager: BaseHeaderableTableDataDisplayManager {
    /// Called if table shows last cell
    public var lastCellShowingEvent = BaseEvent<Void>()


    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cellGenerators[indexPath.section].count - 1 {
            lastCellShowingEvent.invoke(with: ())
        }
    }
}

open class ExtendableHeaderableAdapter: BaseHeaderableTableDataDisplayManager {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderGenerators.isEmpty ? 1 : sectionHeaderGenerators.count
    }
}

