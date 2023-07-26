//
//  CollectionContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public struct CollectionContext {

    @available(*, deprecated, renamed: "gen", message: "Please use `gen` method and `RegistrationTypeProvider` instead")
    public static func cell<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                        model: T.Model,
                                                                        registerType: RegistrationType) -> BaseCollectionCellGenerator<T> {
        T.rddm.baseGenerator(with: model, and: registerType)
    }

}
