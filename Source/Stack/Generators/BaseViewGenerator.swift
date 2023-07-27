//
//  BaseViewGenerator.swift
//  Pods
//
//  Created by Никита Коробейников on 06.09.2021.
//

import UIKit

public final class EmptyViewGenerator<View: ConfigurableItem & RegistrationTypeProvider>: AccessoryViewGenerator {

    public typealias ViewType = View

    public init() { }

    public func generate() -> View {
        switch View.prefferedRegistration {
        case .nib:
            return View.loadFromNib(bundle: ViewType.bundle() ?? .main)
        case .class:
            return View()
        }
    }

}

open class BaseViewGenerator<View: ConfigurableItem>: ViewGenerator, ViewBuilder {

    public let model: View.Model

    // MARK: - Private properties

    private let registerType: RegistrationType

    public init(with model: View.Model,
                registerType: RegistrationType = .class) {
        self.model = model
        self.registerType = registerType
    }

    public func build(view: View) {
        view.configure(with: model)
    }

    public func generate(stackView: UIStackView, index: Int) -> UIView {
        let view = createView()
        self.build(view: view)
        return view
    }

}

// MARK: - Private

private extension BaseViewGenerator {

    func createView() -> ViewType {
        switch registerType {
        case .nib:
            return ViewType.loadFromNib(bundle: ViewType.bundle() ?? .main)
        case .class:
            return ViewType()
        }
    }

}

private extension ConfigurableItem {

    static func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            return T()
        }

        return view
    }

}
