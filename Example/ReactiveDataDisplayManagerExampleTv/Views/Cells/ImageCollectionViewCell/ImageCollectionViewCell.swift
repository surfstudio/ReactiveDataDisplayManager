//
//  ImageCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 09.06.2021.
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
            let stringImageUrl = "https://picsum.photos/id/\(Int.random(in: 0...1000))/640/480"
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

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedItem === self {
            coordinator.addCoordinatedFocusingAnimations { context in
                self.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }

        if context.previouslyFocusedItem === self {
            coordinator.addCoordinatedUnfocusingAnimations { context in
                self.contentView.transform = .identity
            }
        }

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


