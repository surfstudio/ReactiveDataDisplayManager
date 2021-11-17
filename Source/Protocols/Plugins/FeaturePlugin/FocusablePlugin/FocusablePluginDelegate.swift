// 
//  FocusablePluginDelegate.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  

import Foundation
import UIKit

open class FocusablePluginDelegate<Provider: GeneratorsProvider>: FocusableDelegate {

    // MARK: - Typealias

    public typealias GeneratorType = FocusableItem
    var model: FocusedPlaginModel?

    // MARK: - FocusableDelegate

    public func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canBeFocused()
        }
        return false
    }

    func didFocusedCell(previusView: UIView?, nextView: UIView?,
                        indexPath: IndexPath?,
                        collectionView: UICollectionView? = nil,
                        tableView: UITableView? = nil) {
        previusView?.layer.shadowRadius = .zero
        previusView?.layer.shadowOpacity = .zero
        animate(previusView: previusView, nextView: nextView, duration: model?.transformDuration)

        nextView?.layer.shadowColor = model?.shadow?.color
        nextView?.layer.shadowRadius = model?.shadow?.radius ?? .zero
        nextView?.layer.shadowOpacity = model?.shadow?.opacity ?? .zero
        nextView?.layer.shadowOffset = model?.shadow?.offset ?? .zero
        guard let indexPath = indexPath else {
            return
        }
        tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        collectionView?.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }

}

// MARK: - Private Methods

private extension FocusablePluginDelegate {

    func animate(previusView: UIView?, nextView: UIView?, duration: CGFloat?) {
        let zeroTransform: CGAffineTransform = .init(a: .zero, b: .zero, c: .zero, d: .zero, tx: .zero, ty: .zero)
        guard let transform = model?.transform, transform != zeroTransform else {
            return
        }
        UIView.animate(withDuration: duration ?? .zero, animations: {
            previusView?.transform = .identity
            nextView?.transform = transform
        })
    }

}
