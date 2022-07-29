//
//  MockTableCellGenerator.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
import UIKit

@testable import ReactiveDataDisplayManager

class StubTableCellGenerator: BaseCellGenerator<StubTableCell> {

    init(model: String) {
        super.init(with: model, registerType: .class)
    }

}

final class StubTableCell: UITableViewCell, ConfigurableItem {

    func configure(with model: String) {
        accessibilityIdentifier = model

        frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 20))
    }

}
