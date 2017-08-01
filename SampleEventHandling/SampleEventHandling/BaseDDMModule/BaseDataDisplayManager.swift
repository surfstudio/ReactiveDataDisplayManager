//
//  BaseDataDisplayManager.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Содержит базовую имплементацию DataManager и DisplayManager.
/// Умеет регестрировать нибы если это нужно, определять EstimatedHeightRowHeight, heightForRow. 
/// Умеет заполнить таблицу нужными данными.
/// Идея в том, что этот менеджер должен покрыть тривиальные задачи (он не до конца написан, просто на скорую руку - при необходимости можно добавить недостающие компоненты)
/// Если нужно специфиыическое поведения то можно либо сабкласить, либо создавать новый - не важно, главное имплементить протоколы 💪
public class BaseTableDataDisplayManager: NSObject, TableDataManager, TableDisplayManager {

    fileprivate var generators = [TableCellGenerator]()
    fileprivate weak var tableView: UITableView?

    fileprivate let estimatedHeight: CGFloat

    init(estimatedHeight: CGFloat = 40) {
        self.estimatedHeight = estimatedHeight
        super.init()
    }

    func addGenerator(_ generator: TableCellGenerator, needRegister: Bool = true) {
        if needRegister {
            self.tableView?.registerNib(generator.identifier)
        }
        self.generators.append(generator)
    }

    func setTableView(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
    }
}

/// MARK: - UITableViewDelegate

extension BaseTableDataDisplayManager: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.estimatedHeight
    }
}

// MARK: - UITableViewDataSource

extension BaseTableDataDisplayManager: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.generators.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.generators[indexPath.row].generate(tableView: tableView, forIndexPath: indexPath)
    }
}
