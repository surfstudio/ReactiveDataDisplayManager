//
//  BaseStackCellGenerator.swift
//  Pods
//
//  Created by Никита Коробейников on 06.09.2021.
//

open class BaseStackCellGenerator<View: ConfigurableItem>: StackCellGenerator, ViewBuilder {

    public let model: View.Model

    public init(with model: View.Model) {
        self.model = model
    }

    public func build(view: View) {
        view.configure(with: model)
    }

}
