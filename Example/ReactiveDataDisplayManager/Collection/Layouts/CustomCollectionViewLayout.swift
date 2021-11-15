//
//  CollectionViewLayout.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit

/// ** IMPORTANT ** Used by ** preferredAttributes **
/// For everything to work correctly, it is necessary in each cell of the UICollectionViewCell to calculate the height in the ** preferredLayoutAttributesFitting ** method
final class FittingCompressedSizeCollectionViewLayout: UICollectionViewLayout {

    // MARK: - Private Properties

    private let estimatedItemHeight: CGFloat = 300.0

    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = .zero

    private var contentWidth: CGFloat {
        return UIScreen.main.bounds.width - contentInsets.left - contentInsets.right
    }

    private var contentInsets: UIEdgeInsets {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            return .init(top: 12.0, left: 40.0, bottom: 20.0, right: 40.0)
        } else {
            return .init(top: 4.0, left: 20.0, bottom: 20.0, right: 20.0)
        }
    }

    private var interitemSpacing: CGFloat {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            return 16.0
        } else {
            return .zero
        }
    }

    private var lineSpacing: CGFloat {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            return 8.0
        } else {
            return 16.0
        }
    }

    private var itemWidth: CGFloat {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            return (contentWidth - interitemSpacing) / 2.0
        } else {
            return contentWidth
        }
    }

}

// MARK: - UICollectionViewLayout

extension FittingCompressedSizeCollectionViewLayout {

    override var collectionViewContentSize: CGSize {
        return .init(width: contentWidth, height: contentHeight)
    }

    /// Prepares initial layout with hardcode height
    override func prepare() {
        super.prepare()
        guard cachedAttributes.isEmpty else { return }

        cachedAttributes.removeAll()
        contentHeight = .zero

        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            tabletInitialLayout()
        } else {
            phoneInitialLayout()
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.compactMap { attributes -> UICollectionViewLayoutAttributes? in
            guard attributes.frame.intersects(rect) else { return nil }
            return attributes
        }
    }

    /// Checks for changes to the layout, if changed, resets the values
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        guard context.invalidateEverything else { return }
        cachedAttributes.removeAll()
        contentHeight = .zero
    }

    /// We check if the cell size has changed compared to the previous values, if so, we calculate the new size
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {

        if preferredAttributes.frame.size.height == originalAttributes.frame.size.height && originalAttributes.frame.size.width == itemWidth {
            return false
        }

        return true
    }

    /// Updating the layout based on the calculated height inside the cell using autolayout
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                      withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutInvalidationContext {

        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)

        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            tabletFinishLayout(with: context,
                               preferredAttributes: preferredAttributes,
                               originalAttributes: originalAttributes)
        } else {
            phoneFinishLayout(with: context,
                              preferredAttributes: preferredAttributes,
                              originalAttributes: originalAttributes)
        }

        return context
    }

}

// MARK: - Private Methods

private extension FittingCompressedSizeCollectionViewLayout {

    /// Layout for phones with hardcode height
    func phoneInitialLayout() {
        guard let collectionView = collectionView else { return }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)

            let x: CGFloat = contentInsets.left
            let y: CGFloat = (CGFloat(item) * estimatedItemHeight) + lineSpacing

            let origin = CGPoint(x: x, y: y)
            let size = CGSize(width: itemWidth, height: estimatedItemHeight)
            let frame = CGRect(origin: origin, size: size)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cachedAttributes.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
        }
    }

    /// Layout for phones with height calculated from autolayout
    func phoneFinishLayout(with context: UICollectionViewLayoutInvalidationContext,
                           preferredAttributes: UICollectionViewLayoutAttributes,
                           originalAttributes: UICollectionViewLayoutAttributes) {

        let newHeight = preferredAttributes.size.height - originalAttributes.size.height

        let newAttributes = cachedAttributes[originalAttributes.indexPath.row]
        newAttributes.frame.size.height += newHeight
        newAttributes.frame.size.width = itemWidth

        context.invalidateItems(at: [newAttributes.indexPath])
        cachedAttributes[originalAttributes.indexPath.row] = newAttributes

        var maxY: CGFloat = newAttributes.frame.maxY
        cachedAttributes.enumerated().forEach { index, attributes in
            guard index > originalAttributes.indexPath.row else { return }

            attributes.frame.origin.y += newHeight //+ lineSpacing
            if attributes.frame.origin.y - maxY <= .zero {
                attributes.frame.origin.y += lineSpacing
                maxY = attributes.frame.maxY
            }

            context.invalidateItems(at: [attributes.indexPath])
        }

        contentHeight = (cachedAttributes.last?.frame.maxY ?? contentHeight) + contentInsets.bottom
    }

    /// Layout for tablets with hardcode height
    func tabletInitialLayout() {
        guard let collectionView = collectionView else { return }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        var y: CGFloat = .zero

        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)

            let x: CGFloat
            if item % 2 == 0 {
                x = contentInsets.left
                y = contentHeight + lineSpacing
            } else {
                x = contentInsets.left + itemWidth + interitemSpacing
            }

            let origin = CGPoint(x: x, y: y)
            let size = CGSize(width: itemWidth, height: estimatedItemHeight)
            let frame = CGRect(origin: origin, size: size)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cachedAttributes.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
        }
    }

    /// Layout for tablets with height calculated from auto decomposition
    func tabletFinishLayout(with context: UICollectionViewLayoutInvalidationContext,
                            preferredAttributes: UICollectionViewLayoutAttributes,
                            originalAttributes: UICollectionViewLayoutAttributes) {

        let newHeight = preferredAttributes.size.height - originalAttributes.size.height

        let newAttributes = cachedAttributes[originalAttributes.indexPath.row]
        newAttributes.frame.size.height += newHeight
        newAttributes.frame.size.width = itemWidth

        context.invalidateItems(at: [newAttributes.indexPath])
        cachedAttributes[originalAttributes.indexPath.row] = newAttributes

        var x: CGFloat = contentInsets.left
        var y: CGFloat = contentInsets.top
        var contentHeight: CGFloat = .zero
        var maxY: CGFloat = lineSpacing

        cachedAttributes.forEach { attributes in
            attributes.frame.origin = .init(x: x, y: y)

            if x == contentInsets.left {
                x = contentInsets.left + itemWidth + interitemSpacing
                if contentHeight == maxY {
                    y = contentHeight + lineSpacing
                }
            } else {
                x = contentInsets.left
                y = contentHeight + lineSpacing
            }

            if contentHeight > maxY {
                if attributes.frame.origin.x == contentInsets.left {
                    attributes.frame.origin.x = contentInsets.left + itemWidth + interitemSpacing
                    x = contentInsets.left
                } else {
                    attributes.frame.origin.x = contentInsets.left
                    x = contentInsets.left + itemWidth + interitemSpacing
                }

                attributes.frame.origin.y = maxY + lineSpacing
            }

            if self.cachedAttributes.last == attributes,
                self.cachedAttributes.filter({ $0.frame.maxY == attributes.frame.origin.y - lineSpacing }).count > 1,
            self.cachedAttributes.filter({ $0.frame.origin.y == attributes.frame.origin.y }).count == 1 {
                attributes.frame.origin.x = contentInsets.left
            }

            contentHeight = max(contentHeight, attributes.frame.maxY)
            maxY = attributes.frame.maxY

            context.invalidateItems(at: [attributes.indexPath])
        }

        self.contentHeight = contentHeight + contentInsets.top + contentInsets.bottom
    }

}
