//
//  VerticalSizableTextGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class VerticalSizableTextGenerator {

    // MARK: - Private Properties

    private let text: String
    private let maxWight: CGFloat

    // MARK: - Initializers

    public init(with text: String, maxWight: CGFloat) {
        self.text = text
        self.maxWight = maxWight
    }

}

// MARK: - CollectionCellGenerator

extension VerticalSizableTextGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: SizableCollectionViewCell.self)
    }

}

// MARK: - ViewBuilder

extension VerticalSizableTextGenerator: ViewBuilder {

    func build(view: SizableCollectionViewCell) {
        view.configure(with: text)
    }

}

// MARK: - SizableCollectionCellGenerator

extension VerticalSizableTextGenerator: SizableCollectionCellGenerator {

    func getSize() -> CGSize {
        return SizableCollectionViewCell.getCellSize(for: text, withWight: maxWight)
    }

}
