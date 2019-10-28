//
//  TitleStackCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class TitleStackCellGenerator: StackCellGenerator {

    var title: String

    init(title: String) {
        self.title = title
    }
}

// MARK: - StackCellGenerator

extension TitleStackCellGenerator: ViewBuilder {
    func build(view: UILabel) {
        view.text = title
        view.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }
}
