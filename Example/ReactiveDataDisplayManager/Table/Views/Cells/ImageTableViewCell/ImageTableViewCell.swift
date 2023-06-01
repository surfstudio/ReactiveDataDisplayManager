//
//  ImageTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class ImageTableViewCell: UITableViewCell {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL
        let title: String
        let loadImage: (URL, UIImageView) -> Void

        static func make(with loadImage: @escaping (URL, UIImageView) -> Void) -> Self? {
            let stringImageUrl = ImageUrlProvider.getRandomImage(of: .init(width: 1280, height: 720))
            guard let imageUrl = URL(string: stringImageUrl) else { return nil }
            return .init(imageUrl: imageUrl, title: stringImageUrl, loadImage: loadImage)
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let titleFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

}

// MARK: - AccessibilityItem

extension ImageTableViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .merge([iconView, titleLabel]) }
    
}


// MARK: - ConfigurableItem

extension ImageTableViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = String(format: "URL: %@", viewModel.title)
        viewModel.loadImage(viewModel.imageUrl, iconView)
    }

}

// MARK: - Configuration

private extension ImageTableViewCell {

    func setupInitialState() {
        selectionStyle = .none

        // configure titleLabel
        titleLabel.font = Constants.titleFont

        // configure iconView
        iconView.backgroundColor = .lightGray
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = Constants.cornerRadius
        iconView.layer.masksToBounds = true
    }

}
