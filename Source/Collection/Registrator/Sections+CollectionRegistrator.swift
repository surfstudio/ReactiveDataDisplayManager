//
//  Sections+CollectionRegistrator.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public extension Array where Element == Section<CollectionCellGenerator, CollectionHeaderGenerator, CollectionFooterGenerator> {

    func registerAllIfNeeded(with view: UICollectionView, using registrator: Registrator<UICollectionView>) {
        forEach { section in
            registrator.registerIfNeeded(item: section.header, with: view)
            registrator.registerIfNeeded(item: section.footer, with: view)
            section.generators.forEach {
                registrator.registerIfNeeded(item: $0, with: view)
            }
        }
    }

}
