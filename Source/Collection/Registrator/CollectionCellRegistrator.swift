//
//  CollectionCellRegistrator.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public class CollectionCellRegistrator: Registrator<UICollectionView> {

    public override func register(item: RegisterableItem, with view: UICollectionView) {
        switch item {
        case let cell as CollectionCellRegisterableItem:
            cell.registerCell(in: view)
        case let header as CollectionHeaderRegisterableItem:
            header.registerHeader(in: view)
        case let footer as CollectionFooterRegisterableItem:
            footer.registerFooter(in: view)
        default:
            break
        }
    }

}
