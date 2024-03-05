//
//  Decl+Extensions.swift
//
//
//  Created by Никита Коробейников on 25.07.2023.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Struct

extension StructDeclSyntax {

    var variables: [VariableDeclSyntax] {
        return memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { $0.bindingKeyword.text == "var" }
    }


}

// MARK: - Variable

extension VariableDeclSyntax {

    func parseNameAndType() throws -> (name: TokenSyntax, type: TypeSyntax)? {
        guard let variableBinding = bindings.first,
              let variableType = variableBinding.typeAnnotation?.type.trimmed else {
            let variableName = bindings.first?.pattern.trimmedDescription
            throw MacroError.typeAnnotationRequiredFor(variableName: variableName ?? "unknown")
        }

        let variableName = TokenSyntax(stringLiteral: variableBinding.pattern.description)
        
        return (name: variableName, type: variableType)
    }

}

// MARK: - CodeBlockExpression

extension CodeBlockItemSyntax {

    static func stringItem(_ string: String) -> CodeBlockItemSyntax.Item {
        CodeBlockItemSyntax.Item.expr(.init(stringLiteral: string))
    }

}
