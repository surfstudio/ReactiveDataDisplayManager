//
//  MacroPlugin.swift
//  
//
//  Created by Никита Коробейников on 25.07.2023.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MutableMacro.self,
        BuildableMacro.self
    ]
}
