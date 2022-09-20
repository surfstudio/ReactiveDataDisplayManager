//
//  Stack+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 17.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

extension UIStackView: DataDisplayCompatible { }

public extension DataDisplayWrapper where Base: UIStackView {

    var baseBuilder: StackBuilder<BaseStackManager> {
        StackBuilder(view: base, manager: BaseStackManager())
    }

}

public class StackBuilder<T: BaseStackManager> {

    // MARK: - Properties

    let view: UIStackView
    let manager: T

    // MARK: - Initialization

    public init(view: UIStackView, manager: T) {
        self.view = view
        self.manager = manager
    }

    // MARK: - Public Methods

    /// Build view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        manager.view = view
        return manager
    }

}
