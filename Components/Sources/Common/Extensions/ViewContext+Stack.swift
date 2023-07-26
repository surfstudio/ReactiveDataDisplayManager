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

    static func stack(model: StackView.Model) -> ViewGenerator {
        StackView.rddm.viewGenerator(with: model, and: .class)
    }

}
