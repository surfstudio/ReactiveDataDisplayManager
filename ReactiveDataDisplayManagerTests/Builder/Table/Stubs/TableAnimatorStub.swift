//
//  TableAnimatorStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class TableAnimatorStub: Animator<BaseTableManager.CollectionType> {

    // MARK: - Testable Properties

    var generatorsUpdated = false

    // MARK: - Animator

    override func performAnimated(in collection: BaseTableManager.CollectionType, operation: Operation?) {
        generatorsUpdated = true
    }

}
