//
//  StackView.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 19.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

public final class StackView: UIView {

    // MARK: - Private Properties

    private let stackView = UIStackView()
    private lazy var adapter = stackView.rddm.baseBuilder.build()

}

// MARK: - ConfigurableItem

extension StackView: ConfigurableItem {

    // MARK: - Model

    public struct Model: AlignmentProvider {

        // MARK: - Editor

        public struct Property: Editor {
            public typealias Model = StackView.Model

            private let closure: (Model) -> Model

            public init(closure: @escaping (Model) -> Model) {
                self.closure = closure
            }

            public func edit(_ model: Model) -> Model {
                return closure(model)
            }

            public static func children(_ value: [ViewGenerator]) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(children: value)
                    return model
                })
            }

            /// Only for stack. Cannot be included in common macros.
            public static func children(@GeneratorsBuilder<ViewGenerator>_ content: @escaping (ViewContext.Type) -> [ViewGenerator]) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(children: content(ViewContext.self))
                    return model
                })
            }

            public static func style(_ value: StackStyle) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(style: value)
                    return model
                })
            }

            public static func background(_ value: BackgroundStyle?) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(background: value)
                    return model
                })
            }

            public static func alignment(_ value: Alignment) -> Property {
                .init(closure: { model in
                    var model = model
                    model.set(alignment: value)
                    return model
                })
            }

        }

        // MARK: - Public properties

        private(set) public var children: [ViewGenerator] = []
        private(set) public var style: StackStyle = .init(axis: .horizontal,
                                                          spacing: 0,
                                                          alignment: .fill,
                                                          distribution: .fill)
        private(set) public var background: BackgroundStyle?
        private(set) public var alignment: Alignment = .all(.zero)

        // MARK: - Mutation

        mutating func set(children: [ViewGenerator]) {
            self.children = children
        }

        mutating func set(style: StackStyle) {
            self.style = style
        }

        mutating func set(background: BackgroundStyle?) {
            self.background = background
        }

        mutating func set(alignment: Alignment) {
            self.alignment = alignment
        }

        // MARK: - Builder

        public static func build(@EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
            return content(Property.self).reduce(.init(), { model, editor in
                editor.edit(model)
            })
        }

        public static func copy(of original: Model, @EditorBuilder<Property> content: (Property.Type) -> [Property]) -> Self {
            return content(Property.self).reduce(original, { model, editor in
                editor.edit(model)
            })
        }
    }

    // MARK: - Methods

    public func configure(with model: Model) {
        configureConstraints()
        apply(style: model.style)
        applyBackground(style: model.background)

        adapter -= .all
        adapter += model.children
        adapter => .reload
    }

}

// MARK: - Private

private extension StackView {

    func configureConstraints() {
        wrap(subview: stackView, with: .zero)
    }

    func apply(style: StackStyle) {
        stackView.axis = style.axis
        stackView.spacing = style.spacing
        stackView.alignment = style.alignment
        stackView.distribution = style.distribution
    }

    func applyBackground(style: BackgroundStyle?) {
        switch style {
        case .solid(let color):
            stackView.backgroundColor = color
        case .none:
            stackView.backgroundColor = nil
        }
    }

}

// MARK: - RegistrationTypeProvider

extension StackView: RegistrationTypeProvider {

    public static var prefferedRegistration: RegistrationType { .class }

}
