//
//  ViewContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public enum ViewContext {

    public static func viewClass<T: UIView & ConfigurableItem>(type: T.Type,
                                                               model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .class)
    }

    public static func viewNib<T: UIView & ConfigurableItem>(type: T.Type,
                                                             model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .nib)
    }

}
