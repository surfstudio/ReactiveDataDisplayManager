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
    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != nil) { [weak view] in
            view?.reloadItems(at: indexPaths)
        }
    }

    /// Reload sections with animation
    ///
    /// - parameter indexPaths: indexes of reloaded sections
    /// - parameter updateAnimation: animation of reloaded sections
    override func reloadSections(at indexPaths: IndexSet, with updateAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: updateAnimation != nil) { [weak view] in
            view?.reloadSections(indexPaths)
        }
    }

    /// Replace row at specified indexPath
    ///
    /// - parameter indexPath: index of replaced row
    /// - parameter animation: group of animation to remove old item and insert new
    override func replace(at indexPath: IndexPath,
                          with animation: Modifier<UICollectionView, CollectionItemAnimation>.AnimationGroup?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: animation != nil) { [weak view] in
            view?.deleteItems(at: [indexPath])
            view?.insertItems(at: [indexPath])
        }
    }

    /// Replace row at specified indexPath
    ///
    /// - parameters:
    ///     - indexPaths: array with index of removed row
    ///     - insertIndexPaths: array with index of inserted row
    ///     - animation: group of animation to remove old item and insert new
    override func replace(at indexPaths: [IndexPath],
                          on insertIndexPaths: [IndexPath],
                          with animation: Modifier<UICollectionView, CollectionItemAnimation>.AnimationGroup?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: animation != nil) { [weak view] in
            view?.deleteItems(at: indexPaths)
            view?.insertItems(at: insertIndexPaths)
        }
    }

    /// Insert new sections with items at specific position with animation
    ///
    /// - parameter indexDictionary: dictionary where **key** is new section index and value is location of items to insert
    /// - parameter insertAnimation: animation of insert operation
    ///  - Warning: make sure that you do not have mistake in indexes inside `indexDictionary`.
    ///  For example, if you are inserting **many sections** using this method you should notice that **index** cannot be greater than **final number of sections**.
    override func insertSectionsAndRows(at indexDictionary: [Int: [IndexPath]],
                                        with insertAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            let setOfKeys = IndexSet(indexDictionary.keys)
            let allValues = indexDictionary.values.flatMap { $0 }
            view?.insertSections(setOfKeys)
            view?.insertItems(at: allValues)
        }
    }

    /// Insert sections with animation
    ///
    /// - parameter indexPaths: indexes of inserted sections
    /// - parameter insertAnimation: animation of inserted sections
    ///  - Warning: This method will insert an **empty** section only. If you need to insert section with items use `insertSectionsAndRows` instead.
    override func insertSections(at indexPaths: IndexSet, with insertAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            view?.insertSections(indexPaths)
        }
    }

    /// Insert items with animation
    ///
    /// - parameter indexPaths: indexes of inserted items
    /// - parameter insertAnimation: animation of inserted items
    override func insertRows(at indexPaths: [IndexPath], with insertAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: insertAnimation != nil) { [weak view] in
            view?.insertItems(at: indexPaths)
        }
    }

    /// Remove items and section with animation
    ///
    /// - parameter indexPaths: index of removed items
    /// - parameter section: index of removed sections
    /// - parameter removeAnimation: animation of removing old row
    override func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: CollectionItemAnimation?) {
        guard let view = view else { return }
        animator?.perform(in: view, animated: removeAnimation != nil) { [weak view] in
            view?.deleteItems(at: indexPaths)
            if let section = section {
                view?.deleteSections(section)
            }
        }
    }

}
