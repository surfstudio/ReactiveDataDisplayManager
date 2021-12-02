//
//  CollectionGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class CollectionGeneratorsProvider: GeneratorsProvider {

    open var generators = [[CollectionCellGenerator]]()
    open var headers = [CollectionHeaderGenerator]()
    open var footers = [CollectionFooterGenerator]()

    func addCollectionGenerators(with generators: [CollectionCellGenerator], choice section: СhoiceCollectionSection) {
        switch section {
        case .newSection(let section):
            self.addNewSection(section: section, generators: generators)
        case .byIndex(let sectionIndex):
            self.generators[sectionIndex <= 0 ? 0 : sectionIndex].append(contentsOf: generators)
        case .lastSection:
            self.headers.isEmpty || headers.count <= 0 ?
            self.addCollectionGenerators(with: generators, choice: .newSection()) :
            self.addCollectionGenerators(with: generators, choice: .byIndex(headers.count - 1))
        }
    }

    func addNewSection(section: CollectionSection?, generators: [CollectionCellGenerator]) {
        let header = section?.header ?? EmptyCollectionHeaderGenerator()
        let footer = section?.footer ?? EmptyCollectionFooterGenerator()
        self.headers.append(header)
        self.footers.append(footer)
        self.generators.append([])

        guard let index = getIndex(for: header, in: headers) else { return }
        self.generators[index].append(contentsOf: generators)
    }

    func checkEmptySection(for objects: [AnyObject]){
        if self.generators.count != objects.count || objects.isEmpty {
            self.generators.append([])
        }
    }

    /// Support method. Searches for the index of an element.
    func getIndex(for object: AnyObject, in objects: [AnyObject]) -> Int? {
        return objects.firstIndex(where: { $0 === object })
    }

}
