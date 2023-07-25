//
//  BuildableMacroDefinition.swift
//
//
//  Created by Никита Коробейников on 25.07.2023.
//

/// A macro which generate `func build` for all variables inside struct.
/// - Note: builder is based on resultBuilder from Swift 5.4
@attached(member, names: named(set))
public macro Buildable() = #externalMacro(module: "Macros", type: "BuildableMacro")
