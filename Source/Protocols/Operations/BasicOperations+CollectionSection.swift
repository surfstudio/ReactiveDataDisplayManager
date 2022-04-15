//
//  BasicOperations+CollectionSection.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public extension CollectionCellGenerator {

    static func * (left: Self, right: CollectionHeaderGenerator) -> CollectionSectionsProvider.GeneratorsLinkedWithHeader {
        (generators: [left], header: right)
    }

    static func * (left: Self, right: CollectionFooterGenerator) -> CollectionSectionsProvider.GeneratorsLinkedWithFooter {
        (generators: [left], footer: right)
    }

}

public extension Array where Element == CollectionCellGenerator {

    static func * (left: Self, right: CollectionHeaderGenerator) -> CollectionSectionsProvider.GeneratorsLinkedWithHeader {
        (generators: left, header: right)
    }

    static func * (left: Self, right: CollectionFooterGenerator) -> CollectionSectionsProvider.GeneratorsLinkedWithFooter {
        (generators: left, footer: right)
    }

}

public extension CollectionSectionsProvider {

    typealias GeneratorsLinkedWithHeader = (generators: [GeneratorType], header: HeaderGeneratorType)

    typealias GeneratorsLinkedWithFooter = (generators: [GeneratorType], footer: FooterGeneratorType)

    static func += (left: CollectionSectionsProvider, right: Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>) {
        left.addCollectionGenerators(with: right.generators,
                                     choice: .newSection(header: right.header,
                                                         footer: right.footer))
    }

    static func += (left: CollectionSectionsProvider, right: GeneratorsLinkedWithHeader) {

        let collectionSectionChoice: CollectionSectionСhoice = {
            if let sectionIndex = left.sections.firstIndex(where: { $0.header === right.header }) {
                return .byIndex(sectionIndex)
            } else {
                return .lastSection
            }
        }()

        left.addCollectionGenerators(with: right.generators,
                                     choice: collectionSectionChoice)
    }

    static func += (left: CollectionSectionsProvider, right: GeneratorsLinkedWithFooter) {

        let collectionSectionChoice: CollectionSectionСhoice = {
            if let sectionIndex = left.sections.firstIndex(where: { $0.footer === right.footer }) {
                return .byIndex(sectionIndex)
            } else {
                return .lastSection
            }
        }()

        left.addCollectionGenerators(with: right.generators,
                                     choice: collectionSectionChoice)
    }

}
