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

    public let nestedView: View = .init(frame: .zero)

    public var cachedInsets: UIEdgeInsets?

    public var cachedAlignment: Alignment?

}

// MARK: - CalculatableHeightItem

extension CollectionWrappedCell: CalculatableHeightItem where View: CalculatableHeightItem {

    public static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat {
        return View.getHeight(forWidth: width, with: model)
    }

}

// MARK: - CalculatableWidthItem

extension CollectionWrappedCell: CalculatableWidthItem where View: CalculatableWidthItem {

    public static func getWidth(forHeight height: CGFloat, with model: View.Model) -> CGFloat {
        return View.getWidth(forHeight: height, with: model)
    }

}
