//
//  AutoMockable+Defaults.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.09.2022.
//

import Foundation

enum Mocks {

    static func collectionCell() -> CollectionCellGeneratorMock {
        let generator = CollectionCellGeneratorMock()
        generator.descriptor = String(describing: CollectionCellGeneratorMock.self)
        return generator
    }

    static func tableCell() -> TableCellGeneratorMock {
        let generator = TableCellGeneratorMock()
        generator.descriptor = String(describing: TableCellGeneratorMock.self)
        return generator
    }

}
