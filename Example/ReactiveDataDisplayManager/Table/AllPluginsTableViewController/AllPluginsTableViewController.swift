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
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "main_table"
        fillAdapter()
        updateBarButtonItem(with: Constants.startEditing)

        scheduleIfNeeded { [weak self] in
            self?.insertRandomCell()
        }
    }

}

// MARK: - Private methods

private extension AllPluginsTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        adapter.clearCellGenerators()

        addExpandableSection()
        addSelectableSection()
        addFoldableSection()
        addMovableSection()
        addSwipeableSection()
        addPrefetcherableSection()

        // Tell adapter that we've changed generators
        adapter => .reloadWithCompletion { [weak self] in
            self?.insertMoreSections()
        }

    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeTableEditing))
        navigationItem.rightBarButtonItem = button
    }

    /// Insertion of new section with some cells
    func insertMoreSections() {

        guard let existingSectionGenerator = adapter.sections.last?.header else {
            return
        }

        // Create generators
        let newHeaderGenerator = SectionTitleHeaderGenerator(model: "One more section", needSectionIndexTitle: true)
        let generators = Constants.titles.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }

        // Insert them
        adapter.insertSection(after: existingSectionGenerator,
                              new: newHeaderGenerator,
                              generators: generators)
    }

    /// Use this method for UI stress test only.
    /// You can traine here usage of manual manager and different replacing and insertions.
    ///  - Note: some combinations of functions may cause crash and it's normal, because manualBuilder is just wrapper under tableView functions.
    func insertRandomCell() {
        guard let (sectionIndex, sectionGenerator) = adapter.sections
            .compactMap({ $0.header as? SectionTitleHeaderGenerator })
            .enumerated()
            .first(where: { $0.element.title == "Selectable" })
        else {
            return
        }

        let oldIndexes = adapter.sections[sectionIndex].generators.enumerated().map { IndexPath(row: $0.offset, section: sectionIndex) }

        adapter.sections[sectionIndex].generators.removeAll()

        let titles = Bool.random() ? ["One", "Two", "Three"] : ["Four", "Five"]
        let generators = titles.map(createSelectableGenerator(with:))
        adapter.sections[sectionIndex].generators.append(contentsOf: generators)
        adapter.sections.remove(at: sectionIndex)

        let indexes = generators.enumerated().map { IndexPath(row: $0.offset, section: sectionIndex) }

        adapter.sections.insert(Section(generators: generators, header: sectionGenerator), at: sectionIndex)
        adapter.modifier?.replace(at: oldIndexes, on: indexes, with: nil)

        adapter.addSectionHeaderGenerator(SectionTitleHeaderGenerator(model: "Buggy_addition \(Int.random(in: 0...100))",
                                                                      needSectionIndexTitle: false))
        adapter.modifier?.insertSections(at: IndexSet(integer: adapter.sections.count - 1), with: nil)
    }

    @objc
    func changeTableEditing() {
        tableView.isEditing.toggle()
        updateBarButtonItem(with: tableView.isEditing ? Constants.endEditing : Constants.startEditing)
    }

    func addExpandableSection() {
        addHeaderGenerator(with: "Expandable")
        let generator = ExpandableTableCell.rddm.baseGenerator(with: true)
        adapter.addCellGenerator(generator)
    }

    /// Method allow add header and selectable cells into adapter
    func addSelectableSection() {
        addHeaderGenerator(with: "Selectable")

        for titleStr in Constants.titles {
            // Create generator
            let generator = createSelectableGenerator(with: titleStr)

            // Add generator to adapter
            adapter += generator
        }
    }

    func createSelectableGenerator(with title: String) -> TableCellGenerator {
        let generator = TitleTableViewCell.rddm.baseGenerator(with: title)
        generator.didSelectEvent += {
            debugPrint("\(title) selected")
        }

        return generator
    }

    /// Method allow add header and foldable cells into adapter
    func addFoldableSection() {
        addHeaderGenerator(with: "Foldable")

        for _ in 0...3 {
            // Create foldable generator
            let generator = FoldableTableViewCell.rddm.foldableGenerator(with: .init(title: "", isExpanded: false))

            // Create and add child generators
            generator.children = Constants.titles.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }

            // Add generator to adapter
            adapter += generator
        }
    }

    /// Method allow add header and movable cells into adapter
    func addMovableSection() {
        addHeaderGenerator(with: "Movable")

        Constants.movableTitles.forEach {
            let generator = MovableCellGenerator(with: $0)
            adapter += generator
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
            adapter += generator
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
            adapter += generator
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
        adapter += headerGenerator
    }

}

// MARK: - RefreshableOutput

extension AllPluginsTableViewController: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) { [weak self, weak input] in
            DispatchQueue.main.async { [weak self, weak input] in
                self?.adapter -= .all
                self?.fillAdapter()
                input?.endRefreshing()
            }
        }
    }

}
