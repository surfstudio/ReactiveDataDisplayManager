//
//  HeaderableTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 24/09/2017.
//  Copyright © 2017 Александр Кравченков. All rights reserved.
//

import Foundation

/// Protocol for work with cell.
public protocol HeaderableTableDataDisplayManager: class {

    /// Add generator of header for section.
    func addSectionHeaderGenerator(_ generator: HeaderGenerator)

    /// This method is used to add the new cell generator.
    ///
    /// - Parameters:
    ///   - generator: Generator which should be added.
    ///   - header: Header in which is added to generator, if nil generator
    /// will be added to the last header.
    ///   - needRegister: Pass true if needed to register the cell.
    func addCellGenerator(_ generator: TableCellGenerator, toHeader header: HeaderGenerator?, needRegister: Bool)

    /// Set tableView for current manager
    func setTableView(_ tableView: UITableView)
}

public class BaseHeaderableTableDataDisplayManager: NSObject, HeaderableTableDataDisplayManager {

    // MARK: - Events

    /// Called if table scrolled
    public var scrollEvent = BaseEvent<UITableView>()

    // MARK: - Fileprivate properties

    fileprivate var cellGenerators: [[TableCellGenerator]]
    fileprivate var sectionHeaderGenerators: [HeaderGenerator]
    fileprivate weak var tableView: UITableView?
    fileprivate let estimatedHeight: CGFloat

    // MARK: - Initialization and deinitialization

    public init(estimatedHeight: CGFloat = 40) {
        self.estimatedHeight = estimatedHeight
        self.cellGenerators = [[TableCellGenerator]]()
        self.sectionHeaderGenerators = [HeaderGenerator]()
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

public extension BaseHeaderableTableDataDisplayManager {

    /// Added new header for section generator.
    ///
    /// - Parameter generator: new generator.
    public func addSectionHeaderGenerator(_ generator: HeaderGenerator) {
        self.sectionHeaderGenerators.append(generator)
    }

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
        } else {
            // Add to the last section if it exists
            if self.cellGenerators.indices.contains(sectionHeaderGenerators.count - 1) {
                self.cellGenerators[sectionHeaderGenerators.count - 1].append(generator)
            }
        }
    }

    /// Remove all cell generators.
    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    /// Remove all header generators.
    public func clearHeaderGenerators() {
        self.sectionHeaderGenerators.removeAll()
    }

    /// Calling if generators did removed and added again
    public func didRefill() {
        self.tableView?.reloadData()
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

public class PaginableHeaderableTableDataDisplayManager: BaseHeaderableTableDataDisplayManager {
    /// Called if table shows last cell
    public var lastCellShowingEvent = BaseEvent<Void>()

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cellGenerators[indexPath.section].count - 1 {
            lastCellShowingEvent.invoke(with: ())
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
