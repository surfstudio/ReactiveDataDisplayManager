//
//  File.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit

/// ** IMPORTANT ** Used by ** .scrollDirection = .vertical **
/// This layout allows you to nail content to one of the sides (left / right) by specifying the side in the initializer.
/// Default left
final class AlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    public enum Aligment {
        case left, right
    }

    // MARK: - Private Properties

    private lazy var aligment: Aligment = .left
    private var margin: CGFloat = .zero

    // MARK: - Initialization

    public init(aligment: Aligment) {
        super.init()
        self.aligment = aligment
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UICollectionViewFlowLayout

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var maxY: CGFloat = -1.0
        margin = align(to: rect)

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                margin = align(to: rect, layoutAttribute: layoutAttribute)
            }

            layoutAttribute.frame.origin.x = margin
            let nextXPosition = layoutAttribute.frame.width + minimumInteritemSpacing
            margin = align(to: rect, nextXPosition: nextXPosition)
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }

}

// MARK: - Private Methods

private extension AlignedCollectionViewFlowLayout {

    func align(
        to rect: CGRect,
        nextXPosition: CGFloat? = nil,
        layoutAttribute: UICollectionViewLayoutAttributes? = nil
    ) -> CGFloat {
        switch aligment {
        case .left:
            let defaultXPosition = sectionInset.left
            margin += nextXPosition ?? .zero
            return nextXPosition == nil ? defaultXPosition : margin
        case .right:
            let defaultXPosition = rect.width - (layoutAttribute?.frame.width ?? .zero)
            margin -= nextXPosition ?? .zero
            return nextXPosition == nil ? defaultXPosition : margin
        }
    }

}
