//
//  CollectionLabelCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Collection cell with `LabelView`
public final class CollectionLabelCell: UICollectionViewCell, LabelWrapper {

    public typealias Model = LabelView.Model

    // MARK: - Properties

    public private(set) var label: LabelView = .init(frame: .zero)

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
