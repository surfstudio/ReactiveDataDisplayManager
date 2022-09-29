//
//  TableGeneratorsBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 29.09.2022.
//

@resultBuilder
public enum GeneratorsBuilder<Generator> {

    public static func buildExpression(_ expression: Generator) -> [Generator] {
        return [expression]
    }

    public static func buildExpression(_ expressions: [Generator]) -> [Generator] {
        return expressions
    }

    public static func buildExpression(_ expression: ()) -> [Generator] {
        return []
    }

    public static func buildBlock(_ generators: [Generator]...) -> [Generator] {
        return generators.flatMap { $0 }
    }
    
    public static func buildArray(_ generators: [[Generator]]) -> [Generator] {
        Array(generators.joined())
    }

    public static func buildEither(first generator: Generator) -> Generator {
        return generator
    }

    public static func buildEither(second generator: Generator) -> Generator {
        return generator
    }

}

// MARK: - Global Method

public func TableGenerators(@GeneratorsBuilder<TableCellGenerator>_ content: () -> [TableCellGenerator]) -> [TableCellGenerator] {
    content()
}
