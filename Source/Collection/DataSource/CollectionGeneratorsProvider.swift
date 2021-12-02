//
//  CollectionGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class CollectionGeneratorsProvider: GeneratorsProvider {
    open var generators = [[CollectionCellGenerator]]()
    open var headers = [CollectionHeaderGenerator]()
    open var footers = [CollectionFooterGenerator]()
}
