//
//  CollectionGeneratorsBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 29.09.2022.
//

// MARK: - Global Method

/// CollectionGenerators builder
public func CollectionGenerators(
    @GeneratorsBuilder<CollectionCellGenerator>_ content: () -> [CollectionCellGenerator]
) -> [CollectionCellGenerator] {
    content()
}

/// CollectionSections builder
public func CollectionSections(
    @GeneratorsBuilder<CollectionSection>_ content: () -> [CollectionSection]
) -> [CollectionSection] {
    content()
}
