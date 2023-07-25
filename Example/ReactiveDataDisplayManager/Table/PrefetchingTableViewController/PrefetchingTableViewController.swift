//
//  PrefetchingTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class PrefetchingTableViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private let prefetcher = NukeImagePrefetcher(placeholder: #imageLiteral(resourceName: "ReactiveLogo"))
    private lazy var prefetcherablePlugin: TableImagePrefetcherablePlugin = .prefetch(prefetcher: prefetcher)

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: prefetcherablePlugin)
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        DataLoader.sharedUrlCache.removeAllCachedResponses()
        ImageCache.shared.removeAll()
        if let dataCache = ImagePipeline.shared.configuration.dataCache as? DataCache {
            dataCache.removeAll()
        }

        tableView.separatorStyle = .none

        title = "Gallery with prefetching"

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension PrefetchingTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...300 {
            // Create viewModels for cell
            guard let viewModel = ImageTableViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageTableGenerator(with: viewModel)

            // Add generator to adapter
            adapter += generator
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, options: prefetcher.imageLoadingOptions, into: imageView)
    }

}
