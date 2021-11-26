//
//  FocusableStrategy.swift
//  Pods
//
//  Created by porohov on 18.11.2021.
//

import UIKit

/// Allow dragging cells according to strategy
protocol StrategyFocusable{
    /// The method defines the strategy for the drag and drop behavior.
    /// - parameters:
    ///     - source:  Source IndexPath
    ///     - destination: Destination IndexPath
    /// - returns: Returns a Bool value
    func didFocused(previusView: UIView?, nextView: UIView?,
                    indexPath: IndexPath?,
                    collectionView: UICollectionView?,
                    tableView: UITableView?)
}

public enum FocusStrategy: StrategyFocusable {

    /// Allow transformation on focus
    case transform(CGAffineTransform)

    /// Apply shadows on focus
    case shadow(color: UIColor)

    /// Scroll to when focusing
    case scrollTo(align: FocusableAlign)

    /// Customize Focus Model
    case byModel(model: FocusedPlaginModel)

    /// Apply borber on focus
    /// Only works in tableview
    case border(color: UIColor, width: CGFloat)

    private static var model: FocusedPlaginModel?

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collectionView: default value nil, needed to center the selected cell
    ///     - tableView: default value nil, needed to center the selected cell
    func didFocused(previusView: UIView?, nextView: UIView?,
                    indexPath: IndexPath?,
                    collectionView: UICollectionView? = nil,
                    tableView: UITableView? = nil) {
        switch self {
        case .transform(let transform):
            setTransform(transform: transform,
                         previusView: previusView,
                         nextView: nextView)
        case .shadow(color: let color):
            setShadow(color: color,
                      previusView: previusView,
                      nextView: nextView)
        case .scrollTo(let align):
            setScroll(align: align,
                      index: indexPath,
                      collection: collectionView,
                      table: tableView)
        case .byModel(model: let model):
            setByModel(model: model,
                       previusView: previusView,
                       nextView: nextView,
                       index: indexPath,
                       collection: collectionView,
                       table: tableView)
        case .border(color: let color, width: let width):
            setBorder(color: color,
                      width: width,
                      table: tableView,
                      indexPath: indexPath,
                      previusView: previusView,
                      nextView: nextView)
        }
    }

}

// MARK: - Private Properties

private extension FocusStrategy {

    // Configure shadow
    func setShadow(color: UIColor, previusView: UIView?, nextView: UIView?) {
        let shadowModel = FocusStrategy.model?.shadow
        previusView?.layer.shadowRadius = .zero
        previusView?.layer.shadowOpacity = .zero
        nextView?.layer.shadowColor = color.cgColor
        nextView?.layer.shadowRadius = shadowModel?.radius ?? 10.0
        nextView?.layer.shadowOpacity = shadowModel?.opacity ?? 0.9
        nextView?.layer.shadowOffset = shadowModel?.offset ?? CGSize(width: 0, height: 0)
    }

    // Configure transform
    func setTransform(transform: CGAffineTransform, previusView: UIView?, nextView: UIView?) {
        let duration = FocusStrategy.model?.transformDuration ?? 0.5
        UIView.animate(withDuration: duration, animations: {
            previusView?.transform = .identity
            nextView?.transform = transform
        })
    }

    // Configure scroll
    func setScroll(align: FocusableAlign?, index: IndexPath?, collection: UICollectionView? = nil, table: UITableView? = nil) {
        guard let index = index, let align = align else {
            return
        }
        switch align {
        case .left:
            collection?.scrollToItem(at: index, at: [.left], animated: true)
        case .right:
            collection?.scrollToItem(at: index, at: [.right], animated: true)
        case .center:
            table?.scrollToRow(at: index, at: .middle, animated: true)
            collection?.scrollToItem(at: index, at: [.centeredHorizontally, .centeredVertically], animated: true)
        }
    }

    // Customize Focus Model
    func setByModel(model: FocusedPlaginModel,
                    previusView: UIView?,
                    nextView: UIView?,
                    index: IndexPath?,
                    collection: UICollectionView?,
                    table: UITableView?) {
        FocusStrategy.model = model
        setShadow(color: model.shadow?.color ?? .clear,
                  previusView: previusView,
                  nextView: nextView)
        setTransform(transform: model.transform ?? .identity,
                     previusView: previusView,
                     nextView: nextView)
        setScroll(align: model.align,
                  index: index,
                  collection: collection,
                  table: table)
        setBorder(color: model.border?.color ?? .clear,
                  width: model.border?.width ?? .zero,
                  table: table, indexPath: index,
                  previusView: previusView,
                  nextView: nextView)
    }

    // Configure border for table
    func setBorder(color: UIColor,
                   width: CGFloat,
                   table: UITableView? = nil,
                   indexPath: IndexPath?,
                   previusView: UIView?,
                   nextView: UIView?) {
        guard let indexPath = indexPath, let table = table else {
            return
        }
        let borderModel = FocusStrategy.model?.border
        let cell = table.cellForRow(at: indexPath)
        cell?.focusStyle = .custom
        previusView?.layer.borderWidth = .zero
        nextView?.layer.borderWidth = width
        nextView?.layer.borderColor = color.cgColor
        nextView?.layer.cornerRadius = borderModel?.radius ?? 10
        nextView?.clipsToBounds = borderModel?.clipsToBounds ?? false
    }

}
