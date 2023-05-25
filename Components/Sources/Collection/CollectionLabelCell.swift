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

    public let label: LabelView = .init(frame: .zero)

}
