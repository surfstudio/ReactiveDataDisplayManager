//
//  TableSeparatorCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty table cell with `SeparatorView`
public final class TableSeparatorCell: UITableViewCell, SeparatorWrapper {

    public typealias Model = SeparatorView.Model

    // MARK: - Properties

    public let separator: SeparatorView = .init(frame: .zero)

}
