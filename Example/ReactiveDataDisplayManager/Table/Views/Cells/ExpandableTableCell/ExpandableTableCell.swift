//
//  ExpandableTableCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 30.12.2021.
//

import UIKit
import ReactiveDataDisplayManager

class ExpandableTableCell: UITableViewCell, ExpandableItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var buttonHeightConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private var isSmall = true

    // MARK: - Public Properties

    public var onHeightChanged: BaseEvent<CGFloat?> = .init()


    // MARK: - @IBActions

    @IBAction private func buttonTap(_ sender: UIButton) {
        buttonHeightConstraint.constant += isSmall ? 50 : -50
        onHeightChanged.invoke(with: nil)
        isSmall.toggle()
    }

}

// MARK: - ConfigurableItem

extension ExpandableTableCell: ConfigurableItem {

    func configure(with model: ()) {
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }

}
