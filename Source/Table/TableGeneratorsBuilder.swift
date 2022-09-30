//
//  TableGeneratorsBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 29.09.2022.
//

// MARK: - Global Method

public func TableGenerators(
    @GeneratorsBuilder<TableCellGenerator>_ content: () -> [TableCellGenerator]
) -> [TableCellGenerator] {
    content()
}

public func TableSections(
    @GeneratorsBuilder<TableSection>_ content: () -> [TableSection]
) -> [TableSection] {
    content()
}
