//
//  ViewContext+Stack.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

public extension ViewContext {

    /// Used to place `StackView` into other `StackView`
    /// - Parameter model: model which contains styles and children
    static func stack(model: StackView.Model) -> BaseViewGenerator<StackView> {
        StackView.rddm.viewGenerator(with: model, and: .class)
    }

}
