//
//  AutoConstraintKeyboardPositionManager.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import SurfUtils

/// Changing `constraint.constant` by adding `keyboard.height`
///  Restoring `constraint.constant` to previous value after keyboard hiding
public final class AutoConstraintKeyboardPositionManager: KeyboardObservable {

    // MARK: - Nested

    public final class ConstraintConfiguration {
        weak var constraint: NSLayoutConstraint?
        var decreasedValue: CGFloat

        public init(constraint: NSLayoutConstraint?) {
            self.constraint = constraint
            self.decreasedValue = constraint?.constant ?? .zero
        }
    }

    // MARK: - Private Properties

    private weak var view: UIView?
    private let configurations: [ConstraintConfiguration]

    // MARK: - Initialisation

    public init(view: UIView?, configurations: [ConstraintConfiguration]) {
        self.view = view
        self.configurations = configurations
    }

}

// MARK: - CommonKeyboardPresentable

extension AutoConstraintKeyboardPositionManager: CommonKeyboardPresentable {

    public func keyboardWillBeShown(keyboardHeight: CGFloat, duration: TimeInterval) {
        configurations.applyExtended(with: keyboardHeight)
        updateConstraints(duration)
    }

    public func keyboardWillBeHidden(duration: TimeInterval) {
        configurations.applyDecreased()
        updateConstraints(duration)
    }

}

// MARK: - Helpers

fileprivate extension Array where Element == AutoConstraintKeyboardPositionManager.ConstraintConfiguration {

    func applyExtended(with keyboardHeight: CGFloat) {
        forEach {
            $0.constraint?.constant = keyboardHeight + $0.decreasedValue
        }
    }

    func applyDecreased() {
        forEach {
            $0.constraint?.constant = $0.decreasedValue
        }
    }

}

// MARK: - Private Methods

private extension AutoConstraintKeyboardPositionManager {

    func updateConstraints(_ duration: TimeInterval) {
        view?.setNeedsLayout()
        UIView.animate(withDuration: duration) { [weak view] in
            view?.layoutIfNeeded()
        }
    }

}
