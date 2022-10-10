//
//  TableSpacerCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.09.2022.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty table cell with `SpacerView`
public final class TableSpacerCell: UITableViewCell, SpacerWrapper {

    public typealias Model = SpacerView.Model

    // MARK: - Properties

    public private(set) var spacer: SpacerView = .init(frame: .zero)

    // MARK: - Initialization

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
