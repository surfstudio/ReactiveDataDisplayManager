//
//  BaseCollectionManager+Sections.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.06.2021.
//

import UIKit

// MARK: - SectionedDataDisplayManager

extension BaseCollectionManager: SectionedDataDisplayManager {

    public func addSection(_ section: CollectionSection) {
        section.header?.registerHeader(in: view)
        section.footer?.registerFooter(in: view)
        sections.append(section)
    }

    public func removeSection(_ section: CollectionSection) {

        let sectionIndex = sections
            .firstIndex(where: {
                            $0.header === section.header && $0.footer === section.footer
            })

        guard let index = sectionIndex,
            generators.count > index
                else {
                    return
                }

        generators[index].removeAll()
    }

    public func clearAllSections() {
        sections.removeAll()
        clearCellGenerators()
    }

    // TODO: add methods to add generators to section
//    public func addCellGenerator(_ generator: CollectionCellGenerator, toHeader header: CollectionHeaderGenerator) {
//        addCellGenerators([generator], toHeader: header)
//    }
//
//    public func addCellGenerators(_ generators: [CollectionCellGenerator], toHeader header: CollectionHeaderGenerator) {
//        generators.forEach { $0.registerCell(in: view) }
//
//        if self.generators.count != self.sections.count || sections.isEmpty {
//            self.generators.append([CollectionCellGenerator]())
//        }
//
//        if let index = self.sections.firstIndex(where: { $0 === header }) {
//            self.generators[index].append(contentsOf: generators)
//        }
//    }

}
