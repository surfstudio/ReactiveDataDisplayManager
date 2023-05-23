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
        let loadImage: (URL, UIImageView) -> Void

        static func make(with loadImage: @escaping (URL, UIImageView) -> Void) -> Self? {
            let stringImageUrl = ImageUrlProvider.getRandomImage(of: .init(width: 640, height: 480))
            guard let imageUrl = URL(string: stringImageUrl) else { return nil }
            return .init(imageUrl: imageUrl, loadImage: loadImage)
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var iconView: UIImageView!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

}

// MARK: - Configurable

extension ImageCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(viewModel.imageUrl, iconView)
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
