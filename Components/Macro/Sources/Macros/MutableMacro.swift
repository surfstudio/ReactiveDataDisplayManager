import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro which generate `mutating func` for all variables inside struct.
public struct MutableMacro: MemberMacro {

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let baseStruct = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.onlyApplicableToStruct
        }

        let variables = baseStruct.variables

        let functions = try prepareEditorDeclarations(for: variables)

        return functions.compactMap { $0.as(DeclSyntax.self) }
    }

}

// MARK: - Private

private extension MutableMacro {

    static func prepareEditorDeclarations(for variables: [VariableDeclSyntax]) throws -> [FunctionDeclSyntax] {
        try variables.compactMap { variableDecl -> FunctionDeclSyntax? in

            guard let variable = try variableDecl.parseNameAndType() else {
                return nil
            }

            return FunctionDeclSyntax(leadingTrivia: .newlines(2),
                                      modifiers: .init(itemsBuilder: {
                DeclModifierSyntax(name: .keyword(.mutating))
            }),
                                      identifier: .identifier("set"),
                                      signature: .init(input: .init(parameterListBuilder: {
                FunctionParameterSyntax(firstName: variable.name,
                                        type: variable.type)
                
            })),
                                      body: .init(statementsBuilder: {
                ExprSyntax(stringLiteral: "self.\(variable.name.text)=\(variable.name.text)")
            })
            )
        }
    }

}
