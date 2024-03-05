//
//  BuildableMacro.swift
//
//
//  Created by Никита Коробейников on 25.07.2023.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro which generate `func build` for all variables inside struct.
/// - Note: builder is based on resultBuilder from Swift 5.4
public struct BuildableMacro: MemberMacro, ConformanceMacro {

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingConformancesOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [(SwiftSyntax.TypeSyntax, SwiftSyntax.GenericWhereClauseSyntax?)] {
        return [(TypeSyntax(stringLiteral: "EditorWrapper"), nil)]
    }

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let baseStruct = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.onlyApplicableToStruct
        }

        let variables = baseStruct.variables

        let editors = try prepareEditorDeclarations(for: variables)

        let propertyStruct = preparePropertyStruct(for: baseStruct, with: editors)

        let createFunc = try prepareCreateFunction(for: baseStruct)

        var result: [DeclSyntaxProtocol] = []

        result.append(createFunc)
        result.append(propertyStruct)

        return result.compactMap { $0.as(DeclSyntax.self) }
    }

}

// MARK: - Private

private extension BuildableMacro {

    static func prepareCreateFunction(for baseStruct: StructDeclSyntax) throws -> FunctionDeclSyntax {
        guard let baseStuctType = TypeSyntax(baseStruct) else {
            throw MacroError.failedToExtractTypeOfBaseStruct
        }
        
        return .init(modifiers: .init(itemsBuilder: {
            DeclModifierSyntax(name: .keyword(.public))
            DeclModifierSyntax(name: .keyword(.static))
        }),
                     identifier: .identifier("create"),
                     signature: .init(input: .init(parameterListBuilder: { }),
                                      output: .init(returnType: baseStuctType))
        )
    }

    static func preparePropertyStruct(for baseStruct: StructDeclSyntax, with editors: [FunctionDeclSyntax]) -> StructDeclSyntax {
        StructDeclSyntax(modifiers: .init(itemsBuilder: {
            DeclModifierSyntax(name: .keyword(.public))
        }),
                         identifier: .identifier("Property"),
                         memberBlock: .init(membersBuilder: {
            .init(itemsBuilder: {
                TypealiasDeclSyntax(
                    modifiers: .init(itemsBuilder: {
                        DeclModifierSyntax(name: .keyword(.public))
                    }),
                    identifier:
                            .identifier("Model"),
                    initializer: .init(baseStruct)!)

//                VariableDeclSyntax(modifiers: .init(itemsBuilder: {
//                    DeclModifierSyntax(name: .keyword(.private))
//                }), name: .init(stringLiteral: "closure"), .keyword(.let))
            })
        }))
    }

    static func prepareEditorDeclarations(for variables: [VariableDeclSyntax]) throws -> [FunctionDeclSyntax] {
        try variables.compactMap { variableDecl -> FunctionDeclSyntax? in

            guard let variable = try variableDecl.parseNameAndType() else {
                return nil
            }

            return FunctionDeclSyntax(leadingTrivia: .newlines(2),
                                      modifiers: .init(itemsBuilder: {
                DeclModifierSyntax(name: .keyword(.static))
            }),
                                      identifier: .identifier(variable.name.text),
                                      signature: .init(input: .init(parameterListBuilder: {
                FunctionParameterSyntax(leadingTrivia: .space,
                                        firstName: .identifier("value"),
                                        type: variable.type)
            })),
                                      body: CodeBlockSyntax(statementsBuilder: {
                StmtSyntax(stringLiteral: "var model = model")
                StmtSyntax(stringLiteral: "model.set(\(variable.name.text):value)")
                StmtSyntax(stringLiteral: "return model")
            })
            )
        }
    }

}
