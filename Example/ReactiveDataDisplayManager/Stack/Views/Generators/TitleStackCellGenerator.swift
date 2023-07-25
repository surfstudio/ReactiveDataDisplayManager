//
//  TitleStackCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit

final class TitleStackCellGenerator: StackCellGenerator {

    // MARK: - Properties

    var title: String

    // MARK: - Initialization

    init(title: String) {
        self.title = title
    }

}

// MARK: - ViewBuilder

extension TitleStackCellGenerator: ViewBuilder {

    func build(view: UILabel) {
        view.text = title
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

}
