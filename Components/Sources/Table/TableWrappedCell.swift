//
//  TableCell.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 29.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty table cell with `View`. Configuration is implemented within `ViewWrapper`.
public final class TableWrappedCell<View: ConfigurableItem>: UITableViewCell, ViewWrapper {

    public typealias Model = View.Model

    // MARK: - Properties

    public let nestedView: View = .init(frame: .zero)

    public var cachedInsets: UIEdgeInsets?

    public var cachedAlignment: Alignment?

}

// MARK: - CalculatableHeightItem

extension TableWrappedCell: CalculatableHeightItem where View: CalculatableHeightItem {

    public static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat {
        return View.getHeight(forWidth: width, with: model)
    }

}
