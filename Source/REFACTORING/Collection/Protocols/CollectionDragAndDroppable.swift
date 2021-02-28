//
//  CollectionDragAndDroppable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
public protocol CollectionDragAndDroppable: FeaturePlugin {
    func makeDragItems(at indexPath: IndexPath, with manager: BaseCollectionManager?) -> [UIDragItem]
    func performDrop(with coordinator: UICollectionViewDropCoordinator, and manager: BaseCollectionManager?)
    func didUpdateItem(with destinationIndexPath: IndexPath?, and manager: BaseCollectionManager?) -> UICollectionViewDropProposal
}
