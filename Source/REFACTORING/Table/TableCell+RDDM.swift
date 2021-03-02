//
//  TableCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

extension UITableViewCell: DataDisplayConstructable {}

public extension StaticDataDisplayWrapper where Base: UITableViewCell & RDDMConfigurableItem {

    func baseGenerator(with model: Base.Model, and registerType: CellRegisterType = .nib) -> BaseCellGenerator<Base> {
        .init(with: model, registerType: registerType)
    }

}
