//
//  BasicOperations+TableSection.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public extension TableCellGenerator {

    static func * (left: Self, right: TableHeaderGenerator) -> TableSectionsProvider.GeneratorsLinkedWithHeader {
        (generators: [left], header: right)
    }

    static func * (left: Self, right: TableFooterGenerator) -> TableSectionsProvider.GeneratorsLinkedWithFooter {
        (generators: [left], footer: right)
    }

}

public extension Array where Element == TableCellGenerator {

    static func * (left: Self, right: TableHeaderGenerator) -> TableSectionsProvider.GeneratorsLinkedWithHeader {
        (generators: left, header: right)
    }

    static func * (left: Self, right: TableFooterGenerator) -> TableSectionsProvider.GeneratorsLinkedWithFooter {
        (generators: left, footer: right)
    }

}

public extension TableSectionsProvider {

    typealias GeneratorsLinkedWithHeader = (generators: [GeneratorType], header: HeaderGeneratorType)

    typealias GeneratorsLinkedWithFooter = (generators: [GeneratorType], footer: FooterGeneratorType)

    static func += (left: TableSectionsProvider, right: Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>) {
        left.addTableGenerators(with: right.generators,
                                choice: .newSection(header: right.header,
                                                    footer: right.footer))
    }

    static func += (left: TableSectionsProvider, right: GeneratorsLinkedWithHeader) {

        let tableSectionChoice: TableSectionСhoice = {
            if let sectionIndex = left.sections.firstIndex(where: { $0.header === right.header }) {
                return .byIndex(sectionIndex)
            } else {
                return .lastSection
            }
        }()

        left.addTableGenerators(with: right.generators,
                                choice: tableSectionChoice)
    }

    static func += (left: TableSectionsProvider, right: GeneratorsLinkedWithFooter) {

        let tableSectionChoice: TableSectionСhoice = {
            if let sectionIndex = left.sections.firstIndex(where: { $0.footer === right.footer }) {
                return .byIndex(sectionIndex)
            } else {
                return .lastSection
            }
        }()

        left.addTableGenerators(with: right.generators,
                                choice: tableSectionChoice)
    }

}
