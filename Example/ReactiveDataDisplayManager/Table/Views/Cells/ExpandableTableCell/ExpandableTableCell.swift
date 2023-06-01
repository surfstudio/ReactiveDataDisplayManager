//
//  ExpandableTableCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 30.12.2021.
//

import UIKit
import ReactiveDataDisplayManager

class ExpandableTableCell: UITableViewCell, ExpandableItem, AccessibilityInvalidatable {

    // MARK: - IBOutlets

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var buttonHeightConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private var isSmall = true {
        didSet {
            accessibilityInvalidator?.invalidateParameters()
        }
    }

    // MARK: - ExpandableItem Properties

    public var onHeightChanged: BaseEvent<CGFloat?> = .init()
    public var animatedExpandable = true {
        didSet {
            accessibilityInvalidator?.invalidateParameters()
        }
    }

    // MARK: - AccessibilityInvalidatable

    var accessibilityInvalidator: AccessibilityItemInvalidator?

    // MARK: - Actions

    @IBAction private func buttonTap(_ sender: UIButton) {
        buttonHeightConstraint.constant += isSmall ? 50 : -50
        onHeightChanged.invoke(with: nil)
        isSmall.toggle()
    }

    @IBAction private func switchAnimated(_ sender: UISwitch) {
        animatedExpandable = sender.isOn
    }

    override func accessibilityActivate() -> Bool {
        buttonTap(button)
        return true
    }

    @objc
    private func accessibilityActivateSwitch() -> Bool {
        switcher.isOn.toggle()
        return true
    }

}

// MARK: - AccessibilityItem

extension ExpandableTableCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: button) }
    var valueStrategy: AccessibilityStringStrategy {
        .joined([
            .just(isSmall ? "collapsed" : "expanded"),
            .just(", is animated: "),
            .from(object: switcher, keyPath: \.accessibilityValue)
        ])
    }

    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: button) }

    func accessibilityActions() -> [UIAccessibilityCustomAction] {
        let switchAction = UIAccessibilityCustomAction(name: "Toggle animated", target: self, selector: #selector(accessibilityActivateSwitch))
        return [switchAction]
    }

}

// MARK: - ConfigurableItem

extension ExpandableTableCell: ConfigurableItem {

    func configure(with animated: Bool) {
        accessibilityIdentifier = "expandable_cell"
        self.animatedExpandable = animated
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }

}
