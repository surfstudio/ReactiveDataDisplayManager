import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

let testMacros: [String: Macro.Type] = [
    "mutable": MutableMacro.self,
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
            expandedSource: """
            @Mutable
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
            expandedSource: """
            @Mutable
            class SomeStruct {
                let id: String = ""
                var someVar: Bool = false
            }
            """,
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
            expandedSource: """
            @Mutable
            struct SomeStruct {
                let id: String = ""
                var someVar = false
            }
            """,
            macros: testMacros
        )
    }

}
