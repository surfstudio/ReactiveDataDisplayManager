//
//  BaseCollectionManager+Footers.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.06.2021.
//

import UIKit

// MARK: - FooterDataDisplayManager

extension BaseCollectionManager: FooterDataDisplayManager {

    public func addSectionFooterGenerator(_ generator: CollectionFooterGenerator) {
        generator.registerFooter(in: view)
        self.footers.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toFooter footer: CollectionFooterGenerator) {
        addCellGenerators([generator], toFooter: footer)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toFooter footer: CollectionFooterGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.generators.count != self.footers.count || footers.isEmpty {
            self.generators.append([CollectionCellGenerator]())
        }

        if let index = self.footers.firstIndex(where: { $0 === footer }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    public func removeAllGenerators(from footer: CollectionFooterGenerator) {
        guard
            let index = self.footers.firstIndex(where: { $0 === footer }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    public func clearFooterGenerators() {
        self.footers.removeAll()
    }

}
