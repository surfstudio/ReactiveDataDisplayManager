//
//  CollectionDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol CollectionDelegate: CollectionBuilderConfigurable, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    var manager: BaseCollectionManager? { get set }
    var collectionPlugins: PluginCollection<BaseCollectionPlugin<CollectionEvent>> { get set }
    var scrollPlugins: PluginCollection<BaseCollectionPlugin<ScrollEvent>> { get set }
    var movablePlugin: MovablePluginDelegate<CollectionGeneratorsProvider>? { get set }
    @available(iOS 11, *)
    var draggableDelegate: DraggablePluginDelegate<CollectionGeneratorsProvider>? { get set }
    @available(iOS 11, *)
    var droppableDelegate: DroppablePluginDelegate<CollectionGeneratorsProvider, UICollectionViewDropCoordinator>? { get set }
}
