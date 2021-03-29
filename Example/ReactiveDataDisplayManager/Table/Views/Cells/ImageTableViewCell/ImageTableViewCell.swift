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

        static func make() -> Self? {
            let stringImageUrl = "https://picsum.photos/id/\(Int.random(in: 0...1000))/1280/720"
            guard let imageUrl = URL(string: stringImageUrl) else { return nil }
            return .init(imageUrl: imageUrl, title: stringImageUrl)
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let titleFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
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

extension ImageTableViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = String(format: "URL: %@", viewModel.title)
        Nuke.loadImage(with: viewModel.imageUrl, into: iconView)
    }

}

// MARK: - Configuration

private extension ImageTableViewCell {

    func setupInitialState() {
        selectionStyle = .none

        // configure titleLabel
        titleLabel.font = Constants.titleFont

        // configure iconView
        iconView.backgroundColor = .white
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = Constants.cornerRadius
        iconView.layer.masksToBounds = true
    }

}
