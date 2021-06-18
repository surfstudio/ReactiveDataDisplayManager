//
//  BaseCollectionManager+Headers.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.06.2021.
//

import UIKit

// MARK: - HeaderDataDisplayManager

extension BaseCollectionManager: HeaderDataDisplayManager {

    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        generator.registerHeader(in: view)
        self.sections.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toHeader header: CollectionHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toHeader header: CollectionHeaderGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([CollectionCellGenerator]())
        }

        if let index = self.sections.firstIndex(where: { $0 === header }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    public func removeAllGenerators(from header: CollectionHeaderGenerator) {
        guard
            let index = self.sections.firstIndex(where: { $0 === header }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    public func clearHeaderGenerators() {
        self.sections.removeAll()
    }

}
