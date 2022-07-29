//
//  StubCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

class StubCollectionCellGenerator: BaseCollectionCellGenerator<StubCollectionCell> {

    init(model: String) {
        super.init(with: model, registerType: .class)
    }

}

final class StubCollectionCell: UICollectionViewCell, ConfigurableItem {

    func configure(with model: String) {
        accessibilityIdentifier = model
    }

}
