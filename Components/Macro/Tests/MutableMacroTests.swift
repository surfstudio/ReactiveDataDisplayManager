import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros

let testMacros: [String: Macro.Type] = [
    "mutable": MutableMacro.self,
]

final class MutableMacroTests: XCTestCase {

    func testMutableMacro_expansion() {
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

    func testMutableMacro_application() {
        // TODO: - check that macro throwing error 
    }

}
