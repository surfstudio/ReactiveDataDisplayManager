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

    public let label: LabelView = .init(frame: .zero)

}
