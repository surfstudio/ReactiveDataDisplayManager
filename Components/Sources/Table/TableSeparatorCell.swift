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

    public private(set) var separator: SeparatorView = .init(frame: .zero)

    // MARK: - Initialization

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
