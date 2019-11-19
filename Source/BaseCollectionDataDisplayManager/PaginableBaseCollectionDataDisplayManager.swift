//
//  PaginableBaseCollectionDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 19.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

open class PaginableBaseCollectionDataDisplayManager: BaseCollectionDataDisplayManager {

    public var lastCellShowingEvent = BaseEvent<Void>()

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == cellGenerators.count - 1 {
            lastCellShowingEvent.invoke(with: ())
        }
    }
}
