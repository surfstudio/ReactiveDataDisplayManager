//
//  FocusableStrategy.swift
//  Pods
//
//  Created by porohov on 18.11.2021.
//

import UIKit

public enum FocusStrategy<CollectionType> {

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

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collectionView: default value nil, needed to center the selected cell
    ///     - tableView: default value nil, needed to center the selected cell
    func didFocused(previusView: UIView?,
                    nextView: UIView?,
                    indexPath: IndexPath?,
                    collection: CollectionType) {
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
                      collection: collection)
        case .byModel(model: let model):
            setByModel(model: model,
                       previusView: previusView,
                       nextView: nextView,
                       index: indexPath,
                       collection: collection)
        case .border(model: let borderModel):
            setBorder(model: borderModel,
                      table: collection,
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
    func setScroll(align: FocusableAlign?, index: IndexPath?, collection: CollectionType) {
        guard let index = index, let align = align else {
            return
        }
        switch align {
        case .left:
            (collection as? UICollectionView)?.scrollToItem(at: index, at: [.left], animated: true)
        case .right:
            (collection as? UICollectionView)?.scrollToItem(at: index, at: [.right], animated: true)
        case .center:
            (collection as? UITableView)?.scrollToRow(at: index, at: .middle, animated: true)
            (collection as? UICollectionView)?.scrollToItem(at: index, at: [.centeredHorizontally, .centeredVertically], animated: true)
        }
    }

    // Customize Focus Model
    func setByModel(model: FocusedPlaginModel,
                    previusView: UIView?,
                    nextView: UIView?,
                    index: IndexPath?,
                    collection: CollectionType) {
        setShadow(model: model.shadow,
                  previusView: previusView,
                  nextView: nextView)
        setTransform(transform: model.transform ?? .identity,
                     transformDuration: model.transformDuration,
                     previusView: previusView,
                     nextView: nextView)
        setScroll(align: model.align,
                  index: index,
                  collection: collection)
        setBorder(model: model.border,
                  table: collection, indexPath: index,
                  previusView: previusView,
                  nextView: nextView)
    }

    // Configure border for table
    func setBorder(model: FocusablePlaginBorderModel?,
                   table: CollectionType,
                   indexPath: IndexPath?,
                   previusView: UIView?,
                   nextView: UIView?) {
        guard let indexPath = indexPath,
              let table = table as? UITableView,
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
