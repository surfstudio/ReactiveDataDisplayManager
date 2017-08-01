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
protocol TableDataManager: class {

    /// Добавляет новый генератор к менеджеру данных.
    func addGenerator(_ generator: TableCellGenerator, needRegister: Bool)
}

/// Протокол для общения между отображением и адаптером.
protocol TableDisplayManager: class {

    /// Устанавливает таблицу для данного менеджера.
    func setTableView(_ tableView: UITableView)
}

/// Протокол, для передачи логики построения ячейки адаптеру в виде абстрактной ячейки.
protocol TableCellGenerator: class {

    /// Тип ниба, который генерирует данный генератор.
    var identifier: UITableViewCell.Type { get }

    /// Создает ячейку.
    ///
    /// - Parameter tableView: Таблица, в которой создается ячейка.
    /// - Return: Новая ячейка.
    func generate(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell
}

/// Аспект билдера для конкретной ячейки ячейки.
protocol TableCellBuilder {

    associatedtype CellType: UITableViewCell

    /// Выполняет конфигурирование ячейки.
    ///
    /// - Parameter cell: Ячейка которую необходимо сконфигурировать.
    func build(cell: CellType)
}
