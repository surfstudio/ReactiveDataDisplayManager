import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro which generate `mutating func` for all variables inside struct.
public struct MutableMacro: MemberMacro {

    public static func expansion<Declaration, Context>(of node: AttributeSyntax,
                                                       providingMembersOf declaration: Declaration,
                                                       in context: Context) throws -> [DeclSyntax]
    where Declaration: DeclGroupSyntax,
          Context: MacroExpansionContext {
              guard let structDecl = declaration.as(StructDeclSyntax.self) else {
                  throw MacroError.onlyApplicableToStruct
              }

              let variables = structDecl.memberBlock
                  .members

                  .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                  .filter { $0.bindingKeyword.text == "var" }

              let functions = try variables.compactMap { variableDecl -> FunctionDeclSyntax? in
                  guard let variableBinding = variableDecl.bindings.first,
                        let variableType = variableBinding.typeAnnotation?.type.trimmed else {
                      let variableName = variableDecl.bindings.first?.pattern.trimmedDescription
                      throw MacroError.typeAnnotationRequiredFor(variableName: variableName ?? "unknown")
                  }

                  let variableName = TokenSyntax(stringLiteral: variableBinding.pattern.description)

                  let parameter = FunctionParameterSyntax(firstName: variableName, type: variableType)
                  let parameterList = FunctionParameterListSyntax(arrayLiteral: parameter)
                  let modifiers = ModifierListSyntax(arrayLiteral: .init(name: .keyword(.mutating)))
                  let bodyItem = CodeBlockItemSyntax.Item.expr(.init(stringLiteral: "self.\(variableName.text)=\(variableName.text)"))
                  let body = CodeBlockSyntax(statements: .init(arrayLiteral: .init(item: bodyItem)))

                  return FunctionDeclSyntax(leadingTrivia: .newlines(2),
                                            modifiers: modifiers,
                                            identifier: .identifier("set"),
                                            signature: .init(input: .init(parameterList: parameterList)),
                                            body: body
                  )
              }

              return functions.compactMap { $0.as(DeclSyntax.self) }
    }

}

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MutableMacro.self
    ]
}
