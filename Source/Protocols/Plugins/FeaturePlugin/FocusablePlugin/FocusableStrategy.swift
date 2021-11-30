//
//  FocusableStrategy.swift
//  Pods
//
//  Created by porohov on 18.11.2021.
//

import UIKit

/// Allow dragging cells according to strategy
protocol StrategyFocusable {
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
    case transform(transform: CGAffineTransform, durtation: CGFloat)

    /// Apply shadows on focus
    case shadow(model: FocusedPlaginShadowModel)

    /// Scroll to when focusing
    case scrollTo(align: FocusableAlign)

    /// Customize Focus Model
    case byModel(model: FocusedPlaginModel)

    /// Apply borber on focus
    /// Only works in tableview
    case border(model: FocusablePlaginBorderModel)

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
        case .transform(let transform, let duration):
            setTransform(transform: transform,
                         transformDuration: duration,
                         previusView: previusView,
                         nextView: nextView)
        case .shadow(model: let model):
            setShadow(model: model,
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
        case .border(model: let borderModel):
            setBorder(model: borderModel,
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
    func setShadow(model: FocusedPlaginShadowModel?, previusView: UIView?, nextView: UIView?) {
        guard let model = model else { return }
        previusView?.layer.shadowRadius = .zero
        previusView?.layer.shadowOpacity = .zero
        nextView?.layer.shadowColor = model.color.cgColor
        nextView?.layer.shadowRadius = model.radius
        nextView?.layer.shadowOpacity = model.opacity
        nextView?.layer.shadowOffset = model.offset
    }

    // Configure transform
    func setTransform(transform: CGAffineTransform,
                      transformDuration: CGFloat,
                      previusView: UIView?,
                      nextView: UIView?) {
        UIView.animate(withDuration: transformDuration, animations: {
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
        setShadow(model: model.shadow,
                  previusView: previusView,
                  nextView: nextView)
        setTransform(transform: model.transform ?? .identity,
                     transformDuration: model.transformDuration,
                     previusView: previusView,
                     nextView: nextView)
        setScroll(align: model.align,
                  index: index,
                  collection: collection,
                  table: table)
        setBorder(model: model.border,
                  table: table, indexPath: index,
                  previusView: previusView,
                  nextView: nextView)
    }

    // Configure border for table
    func setBorder(model: FocusablePlaginBorderModel?,
                   table: UITableView? = nil,
                   indexPath: IndexPath?,
                   previusView: UIView?,
                   nextView: UIView?) {
        guard let indexPath = indexPath,
              let table = table,
              let model = model else {
            return
        }
        let cell = table.cellForRow(at: indexPath)
        cell?.focusStyle = .custom
        previusView?.layer.borderWidth = .zero
        nextView?.layer.borderWidth = model.width
        nextView?.layer.borderColor = model.color.cgColor
        nextView?.layer.cornerRadius = model.radius
        nextView?.clipsToBounds = model.clipsToBounds
    }

}
