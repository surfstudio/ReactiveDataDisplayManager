//
//  TableLabelCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Table cell with `LabelView`
public final class TableLabelCell: UITableViewCell, LabelWrapper {

    public typealias Model = LabelView.Model

    // MARK: - Properties
    public private(set) var label: LabelView = .init(frame: .zero)

    // MARK: - Initialization
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
