//
//  CollectionCommonModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 16.03.2021.
//

import UIKit

/// Helper class to modify `UICollectionView` cells
///
/// - Note: Based on standard `UICollectionView` methods wrapped in `Animator`
class CollectionCommonModifier: Modifier<UICollectionView, CollectionItemAnimation> {

    // MARK: - Properties

    private var animator: Animator<UICollectionView>?

    // MARK: - Init

    /// - parameter view: parent view
    /// - parameter animator: wrapper of animated operation blocks
    init(view: UICollectionView, animator: Animator<UICollectionView>) {
        super.init(view: view)
        self.animator = animator
    }

    // MARK: - Methods

    /// Reload all collection content
    override func reload() {
        view?.reloadData()
    }

    /// Reload items with animation
    ///
    /// - parameter indexPaths: indexes of reloaded items
    /// - parameter updateAnimation: animation of reloaded items
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != .none) { [weak view] in
            view?.reloadItems(at: indexPaths)
        }
    }

    /// Reload sections with animation
    ///
    /// - parameter indexPaths: indexes of reloaded sections
    /// - parameter updateAnimation: animation of reloaded sections
    override func reloadScetions(at indexPaths: IndexSet, with updateAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != .none) { [weak view] in
            view?.reloadSections(indexPaths)
        }
    }


    /// Replace row at specified indexPath
    ///
    /// - parameter indexPath: index of replaced row
    /// - parameter removeAnimation: animation of removing old row
    /// - parameter insertAnimation: animation of inserting new row
    override func replace(at indexPath: IndexPath, with removeAnimation: CollectionItemAnimation, and insertAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != .none) { [weak view] in
            view?.deleteItems(at: [indexPath])
            view?.insertItems(at: [indexPath])
        }
    }

    /// Insert sections with animation
    ///
    /// - parameter indexPaths: indexes of inserted sections
    /// - parameter insertAnimation: animation of inserted sections
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != .none) { [weak view] in
            view?.insertSections(indexPaths)
        }
    }

    /// Insert items with animation
    ///
    /// - parameter indexPaths: indexes of inserted items
    /// - parameter insertAnimation: animation of inserted items
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != .none) { [weak view] in
            view?.insertItems(at: indexPaths)
        }
    }

    /// Remove items and section with animation
    ///
    /// - parameter indexPaths: index of removed items
    /// - parameter section: index of removed sections
    /// - parameter removeAnimation: animation of removing old row
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: CollectionItemAnimation) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: removeAnimation != .none) { [weak view] in
            view?.deleteItems(at: indexPaths)
            if let section = section {
                view?.deleteSections(section)
            }
        }
    }

}

