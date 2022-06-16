//
//  AllPluginsTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class AllPluginsTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titles = ["One", "Two", "Three", "Four"]
        static let movableTitles = [String](repeating: "Movable cell", count: 4)
        static let startEditing = "Start editing"
        static let endEditing = "End editing"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private let prefetcher = NukeImagePrefetcher(placeholder: #imageLiteral(resourceName: "ReactiveLogo"))
    private let swipeActionProvider = SwipeActionProvider()
    private lazy var prefetcherablePlugin: TableImagePrefetcherablePlugin = .prefetch(prefetcher: prefetcher)

    private lazy var scrollDirectionEvent: (ScrollDirection) -> Void = { [weak self] direction in
        switch direction {
        case .up:
            self?.title = "Scrolling to up"
        case .down:
            self?.title = "Scrolling to down"
        default:
            break
        }
    }

    private let headerVisibleEvent: (Int) -> Void = { sectionIndex in
        print("Header with index \(sectionIndex) began to display.")
    }

    private let lastCellIsVisibleEvent: () -> Void = {
        print("Last cell is visible")
    }

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .displayable())
        .add(plugin: .direction(action: scrollDirectionEvent))
        .add(plugin: .headerIsVisible(action: headerVisibleEvent))
        .add(plugin: .lastCellIsVisible(action: lastCellIsVisibleEvent))
        .add(plugin: .selectable())
        .add(plugin: prefetcherablePlugin)
        .add(plugin: .foldable())
        .add(featurePlugin: .movable())
        .add(plugin: .refreshable(refreshControl: UIRefreshControl(), output: self))
        .add(featurePlugin: .swipeActions(swipeProvider: swipeActionProvider))
        .add(featurePlugin: .sectionTitleDisplayable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
        updateBarButtonItem(with: Constants.startEditing)
    }

}

// MARK: - Private methods

private extension AllPluginsTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        addExpandableSection()
        addSelectableSection()
        addFoldableSection()
        addMovableSection()
        addSwipeableSection()
        addPrefetcherableSection()

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeTableEditing))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func changeTableEditing() {
        tableView.isEditing.toggle()
        updateBarButtonItem(with: tableView.isEditing ? Constants.endEditing : Constants.startEditing)
    }

    func addExpandableSection() {
        addHeaderGenerator(with: "Expandable")
        let generator = ExpandableTableCell.rddm.baseGenerator(with: ())
        adapter.addCellGenerator(generator)
    }

    /// Method allow add header and selectable cells into adapter
    func addSelectableSection() {
        addHeaderGenerator(with: "Selectable")

        for titleStr in Constants.titles {
            // Create generator
            let generator = TitleTableViewCell.rddm.baseGenerator(with: titleStr)
            generator.didSelectEvent += {
                debugPrint("\(titleStr) selected")
            }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }

    /// Method allow add header and foldable cells into adapter
    func addFoldableSection() {
        addHeaderGenerator(with: "Foldable")

        for _ in 0...3 {
            // Create foldable generator
            let generator = FoldableCellGenerator(with: .init(title: "", isExpanded: false))

            // Create and add child generators
            generator.childGenerators = Constants.titles.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }

    /// Method allow add header and movable cells into adapter
    func addMovableSection() {
        addHeaderGenerator(with: "Movable")

        Constants.movableTitles.enumerated().forEach {
            let generator = MovableCellGenerator(id: $0.offset, model: $0.element)
            adapter.addCellGenerator(generator)
        }
    }

    /// Method allow add header and swipeable cells into adapter
    func addSwipeableSection() {
        addHeaderGenerator(with: "Swipeable")

        Constants.titles.forEach {
            // Create generator
            let generator = SwipeableTableGenerator(with: $0)

            generator.didSwipeEvent += { [weak generator] actionType in
                guard let generator = generator else { return }
                debugPrint("The action with type \(actionType) was selected from all available generator events \(generator.actionTypes)")
            }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }

    /// Method allow add header and cells with prefetching data into adapter
    func addPrefetcherableSection() {
        addHeaderGenerator(with: "Prefetching")

        for _ in 0...20 {
            // Create viewModels for cell
            guard let viewModel = ImageTableViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageTableGenerator(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, options: prefetcher.imageLoadingOptions, into: imageView)
    }

    func addHeaderGenerator(with title: String) {
        // Make header generator
        let headerGenerator = SectionTitleHeaderGenerator(model: title, needSectionIndexTitle: true)

        headerGenerator.didEndDisplayEvent += {
            print("Header with title \(title) did end to display")
        }

        // Add header generator into adapter
        adapter.addSectionHeaderGenerator(headerGenerator)
    }

}

// MARK: - RefreshableOutput

extension AllPluginsTableViewController: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) { [weak self, weak input] in
            DispatchQueue.main.async { [weak self, weak input] in
                self?.adapter.clearCellGenerators()
                self?.adapter.clearHeaderGenerators()
                self?.fillAdapter()
                input?.endRefreshing()
            }
        }
    }

}
