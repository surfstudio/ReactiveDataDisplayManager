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
    @GeneratorsBuilder<Section<
    TableCellGenerator,
    TableHeaderGenerator,
    TableFooterGenerator
>>_ content: () -> [Section<
                    TableCellGenerator,
                    TableHeaderGenerator,
                    TableFooterGenerator
                >]
) -> [Section<
      TableCellGenerator,
      TableHeaderGenerator,
      TableFooterGenerator
  >] {
    content()
}
