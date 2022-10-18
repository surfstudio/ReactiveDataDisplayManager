// 
//  ImageDefaultBehavoirCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 27.07.2021.
//  
//

import UIKit
import ReactiveDataDisplayManager

final class ImageDefaultBehavoirCollectionViewCell: UICollectionViewCell {

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

extension ImageDefaultBehavoirCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ImageViewModel) {
        viewModel.loadImage(viewModel.imageUrl, iconView)
    }

}

// MARK: - Configuration

private extension ImageDefaultBehavoirCollectionViewCell {

    func setupInitialState() {
        // configure iconView
        iconView.backgroundColor = .lightGray
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = Constants.cornerRadius
        iconView.adjustsImageWhenAncestorFocused = true
    }

}
