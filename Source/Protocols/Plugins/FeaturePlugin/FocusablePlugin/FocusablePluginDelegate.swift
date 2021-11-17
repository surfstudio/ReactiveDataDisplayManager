// 
//  FocusablePluginDelegate.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  

import Foundation
import UIKit

/// Delegate based on `FocusableDelegate` protocol.
open class FocusablePluginDelegate<Provider: GeneratorsProvider>: FocusableDelegate {

    // MARK: - Typealias

    public typealias GeneratorType = FocusableItem
    var model: FocusedPlaginModel?

    // MARK: - FocusableDelegate

    ///  Returns a boolean value whether to start focus or not
    ///  - Parameters:
    ///     - indexPath: IndexPath table or collection
    ///     - provider: Takes a collection or table manager
    public func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canBeFocused()
        }
        return false
    }

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collectionView: default value nil, needed to center the selected cell
    ///     - tableView: default value nil, needed to center the selected cell
    public func didFocusedCell(previusView: UIView?, nextView: UIView?,
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
        guard let indexPath = indexPath, model?.center ?? false else {
            return
        }
        tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        collectionView?.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }

}

// MARK: - Private Methods

private extension FocusablePluginDelegate {

    // Animating the selected view
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
