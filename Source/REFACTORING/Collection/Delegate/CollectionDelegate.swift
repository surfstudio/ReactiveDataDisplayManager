//
//  CollectionDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol CollectionDelegate: UICollectionViewDelegate {
    var manager: BaseCollectionManager? { get set }
    var collectionPlugins: PluginCollection<BaseCollectionPlugin<CollectionEvent>> { get set }
    var scrollPlugins: PluginCollection<BaseCollectionPlugin<ScrollEvent>> { get set }
}
