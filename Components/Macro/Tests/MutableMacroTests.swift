import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

let testMacros: [String: Macro.Type] = [
    "Mutable": MutableMacro.self
]

final class MutableMacroTests: XCTestCase {

    func testExpansionSucceded_whenAppliedToStruct_withVariablesAndType() {
        assertMacroExpansion(
            """
            @Mutable
            struct SomeStruct {
                let id: String = ""
                var someVar: Bool = false
            }
            """,
            expandedSource:
            """

            struct SomeStruct {
                let id: String = ""
                var someVar: Bool = false

                mutating func set(someVar: Bool) {
                    self.someVar = someVar
                }
            }
            """,
            macros: testMacros
        )
    }

    func testExpansionFailed_whenAppliedTo_nonStruct() {
        assertMacroExpansion(
            """
            @Mutable
            class SomeStruct {
                let id: String = ""
                var someVar: Bool = false
            }
            """,
            expandedSource:
            """

            class SomeStruct {
                let id: String = ""
                var someVar: Bool = false
            }
            """,
            diagnostics: [
                .init(message: "onlyApplicableToStruct",
                      line: 1,
                      column: 1)
            ],
            macros: testMacros
        )
    }

    func testExpansionFailed_whenAppliedTo_variableWithoutAnnotation() {
        assertMacroExpansion(
            """
            @Mutable
            struct SomeStruct {
                let id: String = ""
                var someVar = false
            }
            """,
            expandedSource:
            """

            struct SomeStruct {
                let id: String = ""
                var someVar = false
            }
            """,
            diagnostics: [
                .init(message: "typeAnnotationRequiredFor(variableName: \"someVar\")",
                      line: 1,
                      column: 1)
            ],
            macros: testMacros
        )
    }

}
