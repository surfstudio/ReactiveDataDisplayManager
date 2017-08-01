//
//  Protocols.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Протокол для общения между презентером и адаптером.
public protocol TableDataManager: class {

    /// Добавляет генератор хедеров дял секций
    func addSectionHeaderGenerator(_ generator: ViewGenerator)

    /// Добавляет новый генератор ячейки к менеджеру данных.
    func addCellGenerator(_ generator: TableCellGenerator, needRegister: Bool)
}

/// Протокол для общения между отображением и адаптером.
public protocol TableDisplayManager: class {

    /// Устанавливает таблицу для данного менеджера.
    func setTableView(_ tableView: UITableView)
}

/// Протокол для передачи логики построения View адаптеру в виде абстрактной View
public protocol ViewGenerator: class {

    func generate() -> UIView
}

/// Протокол, для передачи логики построения ячейки адаптеру в виде абстрактной ячейки.
public protocol TableCellGenerator: class {

    /// Тип ниба, который генерирует данный генератор.
    var identifier: UITableViewCell.Type { get }

    /// Создает ячейку.
    ///
    /// - Parameter tableView: Таблица, в которой создается ячейка.
    /// - Return: Новая ячейка.
    func generate(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell
}

/// Аспект билдера для конкретной UIVIew.
public protocol ViewBuilder {

    associatedtype ViewType: UIView

    /// Выполняет конфигурирование ячейки.
    ///
    /// - Parameter view: UIView которое необходимо сконфигурировать.
    func build(view: ViewType)
}
