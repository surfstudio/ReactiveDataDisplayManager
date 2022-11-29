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

    // MARK: - ExpandableItem Properties

    public var onHeightChanged: BaseEvent<CGFloat?> = .init()
    public var animatedExpandable: Bool = true

    // MARK: - @IBActions

    @IBAction private func buttonTap(_ sender: UIButton) {
        buttonHeightConstraint.constant += isSmall ? 50 : -50
        onHeightChanged.invoke(with: nil)
        isSmall.toggle()
    }

    @IBAction private func switchAnimated(_ sender: UISwitch) {
        animatedExpandable = sender.isOn
    }

}

// MARK: - ConfigurableItem

extension ExpandableTableCell: ConfigurableItem {

    func configure(with animated: Bool) {
        self.animatedExpandable = animated
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }

}
