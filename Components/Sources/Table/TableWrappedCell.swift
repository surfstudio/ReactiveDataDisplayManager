//
//  TableCell.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 29.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty table cell with `View`
public final class TableWrappedCell<View: ConfigurableItem>: UITableViewCell, ViewWrapper {
    
    public typealias Model = View.Model

    // MARK: - Properties

    public let nestedView: View = .init(frame: .zero)

}
