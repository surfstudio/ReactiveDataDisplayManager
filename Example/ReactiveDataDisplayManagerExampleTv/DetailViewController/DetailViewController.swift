//
//  DetailViewController.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by porohov on 03.04.2022.
//

import UIKit

// UIFocusGuide example
class DetailViewController: UIViewController {

    // MARK: - @IBOutlets

    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var oneButton: UIButton!
    @IBOutlet private weak var twoButton: UIButton!
    @IBOutlet private weak var threeButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFocus()
    }

    @IBAction private func backButtonTap(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func configure(with viewModel: ImageViewModel) {
        viewModel.loadImage(viewModel.imageUrl, imageView)
    }

}

// MARK: - Private

private extension DetailViewController {

    func configureFocus() {
        addFocusGuide(from: containerStackView, to: nextButton, direction: .right)
        addFocusGuide(from: nextButton, to: threeButton, direction: .top)
    }

}

extension UIViewController {

    /// parametr direction: UIRectEdge not support case .all
    func addFocusGuide(from origin: UIView, to destination: UIView, direction: UIRectEdge) {
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        focusGuide.preferredFocusEnvironments = [destination]

        // Configure size to match origin view
        focusGuide.widthAnchor.constraint(equalTo: origin.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: origin.heightAnchor).isActive = true

        switch direction {
        case .bottom: // swipe down
            focusGuide.topAnchor.constraint(equalTo: origin.bottomAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .top: // swipe up
            focusGuide.bottomAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .left: // swipe left
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.rightAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .right: // swipe right
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.rightAnchor).isActive = true
        default:
            break
        }
    }

}
