//
//  TwoDirectionPaginatableTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 20.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class TwoDirectionPaginatableTableViewController: UIViewController {

    // MARK: - Nested types

    private enum ScrollDirection {
        case top
        case bottom
    }

    // MARK: - Constants

    private enum Constants {
        static let maxPagesCount = 5
        static let pageSize = 40
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
        static let paginatorViewHeight: CGFloat = 80
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var bottomProgressView = PaginatorView(frame: .init(x: 0,
                                                                     y: 0,
                                                                     width: tableView.frame.width,
                                                                     height: Constants.paginatorViewHeight))
    private lazy var topProgressView = PaginatorView(frame: .init(x: 0,
                                                                  y: 0,
                                                                  width: tableView.frame.width,
                                                                  height: Constants.paginatorViewHeight))

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .topPaginatable(progressView: topProgressView, output: self))
        .add(plugin: .bottomPaginatable(progressView: bottomProgressView, output: self))
        .build()

    private weak var bottomPaginatableInput: PaginatableInput?
    private weak var topPaginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentTopPage = 0
    private var currentBottomPage = 0

    private var sectionHeader: TableHeaderGenerator = EmptyTableHeaderGenerator()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with two directions pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
    }

}

// MARK: - Configuration

private extension TwoDirectionPaginatableTableViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension TwoDirectionPaginatableTableViewController {

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // hide footer and header
        bottomPaginatableInput?.updatePaginationEnabled(false, at: .forward(.bottom))
        topPaginatableInput?.updatePaginationEnabled(false, at: .backward(.top))

        // imitation of loading first page
        delay(.now() + .seconds(1)) { [weak self] in

            // fill table
            self?.fillAdapter()

            // scroll to middle
            self?.tableView.scrollToRow(at: Constants.firstPageMiddleIndexPath, at: .middle, animated: false)

            // hide loader
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true

            // show pagination loader if update is needed
            self?.bottomPaginatableInput?.updatePaginationEnabled(true, at: .forward(.bottom))
            self?.topPaginatableInput?.updatePaginationEnabled(true, at: .backward(.top))
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        adapter.addSectionHeaderGenerator(sectionHeader)

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    private func makeGenerator(for scrollDirection: ScrollDirection? = nil) -> TableCellGenerator {
        var currentPage = 0
        if let scrollDirection = scrollDirection {
            switch scrollDirection {
            case .top:
                currentPage = currentTopPage
            case .bottom:
                currentPage = currentBottomPage
            }
        }

        return TitleTableViewCell.rddm.calculatableHeightGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
    }

    func canFillPages() -> Bool {
        if isFirstPageLoading {
            isFirstPageLoading.toggle()
            return false
        } else {
            return true
        }
    }

    func fillNext() -> Bool {
        currentBottomPage += 1

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .bottom)
        }

        adapter.insertAtEnd(to: sectionHeader, new: generators, with: .animated(.bottom))

        return currentBottomPage != Constants.maxPagesCount
    }

    func fillPrev() -> Bool {
        currentTopPage -= 1

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .top)
        }

        adapter.insertAtBeginning(to: sectionHeader, new: generators, with: .notAnimated)

        return abs(currentTopPage) != Constants.maxPagesCount
    }

}

// MARK: - PaginatableOutput

extension TwoDirectionPaginatableTableViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput, at direction: PagingDirection) {
        switch direction {
        case .backward:
            topPaginatableInput = input
        case .forward:
            bottomPaginatableInput = input
        }
    }

    func loadNextPage(with input: PaginatableInput, at direction: PagingDirection) {

        input.updatePaginationState(.loading, at: direction)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillPages() ?? false
            if canFillNext {
                let canIterate: Bool
                switch direction {
                case .backward:
                    canIterate = self?.fillPrev() ?? false
                case .forward:
                    canIterate = self?.fillNext() ?? false
                }

                input?.updatePaginationState(.idle, at: direction)
                input?.updatePaginationEnabled(canIterate, at: direction)
            } else {
                input?.updatePaginationState(.error(SampleError.sample), at: direction)
            }
        }
    }

}
