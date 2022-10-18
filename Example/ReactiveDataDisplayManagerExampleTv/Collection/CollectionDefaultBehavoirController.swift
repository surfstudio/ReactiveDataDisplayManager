// 
//  CollectionDefaultBehavoirController.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 27.07.2021.
//  
//

import Nuke
import UIKit
import ReactiveDataDisplayManager

final class CollectionDefaultBehavoirController: UIViewController {

    // MARK: - Typealias

    typealias ItemsInvalidationResult = (items: [NSCollectionLayoutVisibleItem], offset: CGPoint, environment: NSCollectionLayoutEnvironment)

    // MARK: - Constants

    private enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .scrollOnSelect(to: .centeredHorizontally))
        .add(featurePlugin: .focusable(
            by: CompositeFocusableStrategy(strategys: makeFocusableStrategy())
        ))
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CollectionDefaultBehavoirController"

        configureCollectionView()

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension CollectionDefaultBehavoirController {

    func makeFocusableStrategy() -> [FocusableStrategy<UICollectionView>] {
        let transform = CGAffineTransform(translationX: .zero, y: 20)
        let transform2 = CGAffineTransform(rotationAngle: .pi / 20)
        return [
            TransformFocusableStrategy(model: .init(transform: transform)),
            ShadowFocusableStrategy(model: .init(color: .blue)),
            ScrollFocusableCollectionItem(position: .centeredHorizontally),
            TransformFocusableStrategy(model: .init(transform: transform2, duration: 1, delay: 0.5))
        ]
    }

    func configureCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()

        let size = UIScreen.main.bounds.height / 3
        layout.itemSize = .init(width: size, height: size)
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 50
        layout.scrollDirection = .horizontal
        layout.sectionInset = Constants.edgeInsets
        collectionView.setCollectionViewLayout(layout, animated: false)

    }

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...31 {
            // Create viewModels for cell
            guard let viewModel = ImageViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageDefaultBehavoirCollectionViewGenerator(with: viewModel)

            generator.didSelectEvent += { [weak self] in
                guard
                    let detail = self?.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
                else { return }
                self?.showDetailViewController(detail, sender: nil)
                detail.configure(with: viewModel)
            }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, into: imageView) { [weak self] result in
            let image: UIImage
            switch result {
            case .success(let response):
                image = response.image
            case .failure:
                image = UIImage(color: UIColor.gray, size: imageView.frame.size) ?? UIImage()
            }
            imageView.image = self?.processImage(image: image, withSize: imageView.frame.size)
        }
    }

    private func processImage(image: UIImage, withSize size: CGSize) -> UIImage? {
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.contentsGravity = .resizeAspectFill
        layer.contents = image.cgImage
        UIGraphicsBeginImageContext(size)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: currentContext)
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return processedImage
    }
}
