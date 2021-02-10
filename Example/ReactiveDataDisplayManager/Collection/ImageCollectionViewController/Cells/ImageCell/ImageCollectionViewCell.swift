//
//  ImageCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 10.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL

        static func make() -> Self? {
            let stringImageUrl = "https://picsum.photos/id/\(Int.random(in: 0...1000))/100/100"
            guard let imageUrl = URL(string: stringImageUrl) else { return nil }
            return .init(imageUrl: imageUrl)
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var iconView: UIImageView!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

}

extension ImageCollectionViewCell: Configurable {

    func configure(with viewModel: ViewModel) {
        Nuke.loadImage(with: viewModel.imageUrl, into: iconView)
    }

}

// MARK: - Configuration

private extension ImageCollectionViewCell {

    func setupInitialState() {
        // configure iconView
        iconView.backgroundColor = .lightGray
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = Constants.cornerRadius
        iconView.layer.masksToBounds = true
    }

}

