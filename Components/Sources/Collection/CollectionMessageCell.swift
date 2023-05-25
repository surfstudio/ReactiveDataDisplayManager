//
//  CollectionMessageCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 25.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Collection cell with `MessageView`
public final class CollectionMessageCell: UICollectionViewCell, MessageWrapper {

    public typealias Model = MessageView.Model

    // MARK: - Properties

    public let message: MessageView = .init(frame: .zero)

}
