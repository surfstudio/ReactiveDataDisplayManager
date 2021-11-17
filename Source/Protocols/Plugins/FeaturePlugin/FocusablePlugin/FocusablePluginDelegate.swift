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
        previusView?.transform = model?.transform?.previus ?? .identity

        nextView?.layer.shadowColor = model?.shadow?.color
        nextView?.layer.shadowRadius = model?.shadow?.radius ?? .zero
        nextView?.layer.shadowOpacity = model?.shadow?.opacity ?? .zero
        nextView?.layer.shadowOffset = model?.shadow?.offset ?? .zero
        nextView?.transform = model?.transform?.next ?? .identity
        guard let indexPath = indexPath else {
            return
        }
        tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        collectionView?.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }

}
