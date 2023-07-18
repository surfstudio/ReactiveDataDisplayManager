//
//  BaseCollectionManager+Extension.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import ReactiveDataDisplayManager

extension BaseCollectionManager {

    func contains(generator: CollectionCellGenerator) -> Bool {
        let generatorsFromAllSections = sections.flatMap { $0.generators }

        return generatorsFromAllSections.contains { $0 === generator }
    }

}
