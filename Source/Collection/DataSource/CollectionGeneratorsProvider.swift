//
//  CollectionGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class CollectionGeneratorsProvider: GeneratorsProvider {
    
    public typealias GeneratorType = CollectionCellGenerator
    
    public typealias HeaderGeneratorType = CollectionHeaderGenerator
    
    public typealias FooterGeneratorType = CollectionFooterGenerator
    

    open var sections: [SectionType<CollectionCellGenerator, CollectionHeaderGenerator, CollectionFooterGenerator>] = []

    func addCollectionGenerators(with generators: [CollectionCellGenerator], choice section: СhoiceCollectionSection) {
        switch section {
        case .newSection(let header, let footer):
            self.addGeneratorsInNewSection(generators: generators, for: header, footer: footer)
        case .byIndex(let sectionIndex):
            self.addGeneratorsInSection(by: sectionIndex, generators: generators)
        case .lastSection:
            self.sections.isEmpty || sections.count <= 0 ?
            self.addCollectionGenerators(with: generators, choice: .newSection()) :
            self.addGeneratorsInLastSection(generators: generators)
        }
    }

    func addNewSection(section: SectionType<CollectionCellGenerator, CollectionHeaderGenerator, CollectionFooterGenerator>) {
        sections.append(section)
    }

    func addGeneratorsInLastSection(generators: [CollectionCellGenerator]) {
        let index = sections.count - 1
        sections[index].generators.append(contentsOf: generators)
    }

    func addGeneratorsInNewSection(generators: [CollectionCellGenerator],
                                   for header: CollectionHeaderGenerator? = nil,
                                   footer: CollectionFooterGenerator? = nil) {
        sections.append(.init(generators: generators,
                              header: header ?? EmptyCollectionHeaderGenerator(),
                              footer: footer ?? EmptyCollectionFooterGenerator()))
    }

    func addGeneratorsInSection(by index: Int, generators: [CollectionCellGenerator]) {
        sections[index <= 0 ? 0 : index].generators.append(contentsOf: generators)
    }

    func addHeader(header: CollectionHeaderGenerator) {
        addCollectionGenerators(with: [], choice: .newSection(header: header, footer: nil))
    }

    func addFooter(footer: CollectionFooterGenerator) {
        let index = sections.count - 1
        sections[index <= 0 ? 0 : index].footer = footer
    }

}
