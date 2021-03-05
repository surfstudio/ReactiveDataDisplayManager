//
//  TableModifierSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.03.2021.
//

import UIKit

public protocol TableModifierSource {

    var modifier: Modifier<UITableView, UITableView.RowAnimation>? { get }

    /// Wrapper for private setter of modifier
    ///
    /// - parameter builder: Use builder properties to initialise your builder implementation
    func buildModifier<T: BaseTableManager>(with builder: TableBuilder<T>)
}
