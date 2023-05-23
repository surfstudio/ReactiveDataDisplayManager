//
//  CollectionSeparatorCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty collection cell with `SeparatorView`
public final class CollectionSeparatorCell: UICollectionViewCell, SeparatorWrapper {

    public typealias Model = SeparatorView.Model

    // MARK: - Properties

    public private(set) var separator: SeparatorView = .init(frame: .zero)

    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
