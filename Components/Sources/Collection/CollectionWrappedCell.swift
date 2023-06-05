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

    public var cachedAlignment: NSTextAlignment?

}
