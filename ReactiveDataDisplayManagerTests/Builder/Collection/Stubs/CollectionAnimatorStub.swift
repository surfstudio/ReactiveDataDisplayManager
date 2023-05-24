//
//  CollectionAnimatorStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class CollectionAnimatorStub: Animator<BaseCollectionManager.CollectionType> {

    // MARK: - Testable Properties

    var generatorsUpdated = false

    // MARK: - Animator

    override func performAnimated(in collection: BaseCollectionManager.CollectionType, operation: Operation?) {
        generatorsUpdated = true
    }

}
