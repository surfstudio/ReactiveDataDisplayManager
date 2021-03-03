//
//  GravityFoldableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class GravityFoldableCellGenerator: FoldableCellGenerator {

    // MARK: - Properties

    var heaviness: Int

    // MARK: - Initialization

    init(heaviness: Int = .zero, isExpanded: Bool = false) {
        self.heaviness = heaviness
        super.init(with: .init(title: "with heaviness \(heaviness)", isExpanded: isExpanded))
        self.isExpanded = isExpanded
    }

}

// MARK: - Gravity

extension GravityFoldableCellGenerator: GravityItem {

    func getHeaviness() -> Int {
        return heaviness
    }

}
