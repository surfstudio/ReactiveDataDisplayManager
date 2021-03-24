//
//  CollectionCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

extension UICollectionViewCell: DataDisplayConstructable {}

public extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem {

    func baseGenerator(with model: Base.Model, and registerType: CellRegisterType = .nib) -> BaseCollectionCellGenerator<Base> {
        .init(with: model, registerType: registerType)
    }

}
