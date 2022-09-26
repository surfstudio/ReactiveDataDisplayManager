//
//  CollectionSpacerCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.09.2022.
//

import UIKit
import ReactiveDataDisplayManager

/// Empty collection cell with `SpacerView`
final public class CollectionSpacerCell: UICollectionViewCell, SpacerWrapper {

    public typealias Model = SpacerView.Model

    // MARK: - Properties

    public private(set) var spacer: SpacerView = .init(frame: .zero)

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
