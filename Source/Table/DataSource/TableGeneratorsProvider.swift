//
//  TableGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class TableGeneratorsProvider: GeneratorsProvider {

    open var generators = [[TableCellGenerator]]()
    open var headers = [TableHeaderGenerator]()
    open var footers = [TableFooterGenerator]()

    func addTableGenerators(with generators: [TableCellGenerator], choice section: СhoiceTableSection) {
        switch section {
        case .newSection(let section):
            self.addNewSection(section: section, generators: generators)
        case .byIndex(let sectionIndex):
            self.generators[sectionIndex <= 0 ? 0 : sectionIndex].append(contentsOf: generators)
        case .lastSection:
            self.headers.isEmpty || headers.count <= 0 ?
            self.addTableGenerators(with: generators, choice: .newSection()) :
            self.addTableGenerators(with: generators, choice: .byIndex(headers.count - 1))
        }
    }

    func addNewSection(section: TableSection?, generators: [TableCellGenerator]) {
        let header = section?.header ?? EmptyTableHeaderGenerator()
        let footer = section?.footer ?? EmptyTableFooterGenerator()
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
