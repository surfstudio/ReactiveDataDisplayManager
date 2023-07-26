//
//  BuildableMacrosTests.swift
//
//
//  Created by Никита Коробейников on 25.07.2023.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

final class BuildableMacroTests: XCTestCase {

    let testMacros: [String: Macro.Type] = [
        "Buildable": BuildableMacro.self
    ]

    func testExpansionSucceded_whenAppliedToStruct_withVariablesAndType() {
        assertMacroExpansion(
            """
            @Buildable
            struct SomeStruct {
                let id: String = ""
                var someVar: Bool = false
            }
            """,
            expandedSource:
            """

            struct SomeStruct: EditorWrapper {
                let id: String = ""
                var someVar: Bool = false

                public static func create() -> SomeStruct {
                    .init()
                }

                public struct Property: Editor {
                    public typealias Model = SomeStruct

                    private let closure: (Model) -> Model

                    public init(closure: @escaping (Model) -> Model) {
                        self.closure = closure
                    }

                    public func edit(_ model: Model) -> Model {
                        return closure(model)
                    }

                    public static func someVar(_ value: TextValue) -> Property {
                        .init(closure: { model in
                            var model = model
                            model.set(someVar: value)
                            return model
                        })
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

}
