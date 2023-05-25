//
//  TableMessageCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 25.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Table cell with `LabelView`
public final class TableMessageCell: UITableViewCell, MessageWrapper {

    public typealias Model = MessageView.Model

    // MARK: - Properties

    public let message: MessageView = .init(frame: .zero)

}
