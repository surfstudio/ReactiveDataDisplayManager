//
//  CarouselCollectionViewLayout.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit

final class CarouselCollectionViewLayout: UICollectionViewLayout {

    // MARK: - Private Properties

    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    private var cellSize: CGSize = .zero
    private var padding: CGFloat = .zero
    private var horizontalInsets: UIEdgeInsets = .zero

    // MARK: - Public Methods

    func setCells(size: CGSize, padding: CGFloat, insets: UIEdgeInsets) {
        self.cellSize = size
        self.padding = padding
        self.horizontalInsets = insets
    }

}

// MARK: - UICollectionViewLayout

extension CarouselCollectionViewLayout {

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        guard
            let collectionView = collectionView,
            collectionView.numberOfSections > 0
        else {
            return
        }

        cachedAttributes.removeAll()

        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        let size = CGSize(width: cellSize.width, height: cellSize.height)

        let width = horizontalInsets.left + (size.width + padding) * CGFloat(numberOfItems) + (horizontalInsets.right - padding)
        let height = size.height
        contentSize = CGSize(width: width, height: height)

        for item in 0..<numberOfItems {
            let x = horizontalInsets.left + CGFloat(item) * (size.width + padding)
            let origin = CGPoint(x: x, y: padding)
            let frame = CGRect(origin: origin, size: size)
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cachedAttributes.append(attributes)
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let maxProposedOffsetX = collectionViewContentSize.width - (collectionView?.bounds.width ?? 0.0)
        guard proposedContentOffset.x < maxProposedOffsetX else { return proposedContentOffset }

        let proposedX = proposedContentOffset.x + padding

        let sortedAttributes = cachedAttributes.sorted { lhs, rhs in
            return abs(lhs.frame.origin.x - proposedX) < abs(rhs.frame.origin.x - proposedX)
        }

        guard let closest = sortedAttributes.first else { return proposedContentOffset }

        let x = closest.frame.origin.x == horizontalInsets.left
            ? round(closest.frame.origin.x - horizontalInsets.left)
            : round(closest.frame.origin.x - padding)

        return CGPoint(x: x, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.compactMap { attributes -> UICollectionViewLayoutAttributes? in
            guard rect.intersects(attributes.frame) else { return nil }

            return attributes
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
