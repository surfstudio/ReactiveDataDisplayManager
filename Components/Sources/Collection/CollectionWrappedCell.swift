//
//  CollectionCell.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 29.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty collection cell with `View`. Configuration is implemented within `ViewWrapper`.
public final class CollectionWrappedCell<View: ConfigurableItem>: UICollectionViewCell, ViewWrapper {

    public typealias Model = View.Model

    // MARK: - Properties

    // TODO: - Add way to construct nested view from nib (like in BaseViewGenerator)
    public let nestedView: View = .init(frame: .zero)

    public var cachedInsets: UIEdgeInsets?

    public var cachedAlignment: Alignment?

}

// MARK: - CalculatableHeightItem

extension CollectionWrappedCell: CalculatableHeightItem where View: CalculatableHeightItem {

    public static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat {
        let nestedViewHeight = View.getHeight(forWidth: width, with: model)
        if let alignment = (model as? AlignmentProvider)?.alignment {
            switch alignment {
            case .leading(let insets), .trailing(let insets), .all(let insets):
                return nestedViewHeight + insets.top + insets.bottom
            }
        } else {
            return nestedViewHeight
        }
    }

}

// MARK: - CalculatableWidthItem

extension CollectionWrappedCell: CalculatableWidthItem where View: CalculatableWidthItem {

    public static func getWidth(forHeight height: CGFloat, with model: View.Model) -> CGFloat {
        let nestedViewWidth = View.getWidth(forHeight: height, with: model)
        if let alignment = (model as? AlignmentProvider)?.alignment {
            switch alignment {
            case .leading(let insets), .trailing(let insets), .all(let insets):
                return nestedViewWidth + insets.left + insets.right
            }
        } else {
            return nestedViewWidth
        }
    }

}
