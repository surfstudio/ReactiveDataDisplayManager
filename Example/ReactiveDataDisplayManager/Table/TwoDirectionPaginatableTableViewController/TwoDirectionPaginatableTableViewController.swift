//
//  TwoDirectionPaginatableTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 20.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class TwoDirectionPaginatableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 40
        static let pagesCount = 10
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var forwardProgressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))
    private lazy var backwardProgressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .paginatable(progressView: forwardProgressView,
                                  output: self))
        .add(plugin: .paginatable(progressView: backwardProgressView,
                                  output: self,
                                  direction: .backward))
        .build()

    private weak var forwardPaginatableInput: PaginatableInput?
    private weak var backwardPaginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentPage = 0

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
        forwardPaginatableInput?.updatePagination(canIterate: false)
        backwardPaginatableInput?.updatePagination(canIterate: false)

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
            self?.forwardPaginatableInput?.updatePagination(canIterate: true)
            self?.backwardPaginatableInput?.updatePagination(canIterate: true)
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    func makeGenerator() -> TableCellGenerator {
        TitleTableViewCell.rddm.baseGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
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
        currentPage += 1

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload

        return currentPage < Constants.pagesCount
    }

    func fillPrev() -> Bool {
        currentPage += 1

        for _ in 0...Constants.pageSize {
            adapter.insert(before: adapter.sections[safe: 0]!.generators[safe: 0]!, new: makeGenerator())
        }

        adapter => .reload

        return currentPage < Constants.pagesCount
    }

}

// MARK: - RefreshableOutput

extension TwoDirectionPaginatableTableViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        if ((input as? TableBackwardPaginatablePlugin) != nil) {
            backwardPaginatableInput = input
        } else {
            forwardPaginatableInput = input
        }
    }

    func loadNextPage(with input: PaginatableInput) {
        if ((input as? TablePaginatablePlugin) != nil) {
            input.updateProgress(isLoading: true)
            
            delay(.now() + .seconds(2)) { [weak self, weak input] in
                let canFillPages = self?.canFillPages() ?? false

                if canFillPages {
                    let canIterate = self?.fillNext() ?? false
                    
                    input?.updateProgress(isLoading: false)
                    input?.updatePagination(canIterate: canIterate)
                } else {
                    input?.updateProgress(isLoading: false)
                    input?.updateError(SampleError.sample)
                }
            }
        }
    }

    func loadPrevPage(with input: PaginatableInput) {
        if ((input as? TableBackwardPaginatablePlugin) != nil) {
            input.updateProgress(isLoading: true)

            delay(.now() + .seconds(2)) { [weak self, weak input] in
                guard let self = self else {
                    return
                }

                if self.canFillPages() {
                    let canIterate = self.fillPrev()
                    let middleSection = self.adapter.sections.count / 2
                    let middleRow = ((self.adapter.sections[safe: self.adapter.sections.count / 2]?.generators.count ?? 0) / 2)
                    self.adapter.scrollTo(generator: self.adapter.sections[middleSection].generators[middleRow], scrollPosition: .middle, animated: false)

                    input?.updateProgress(isLoading: false)
                    input?.updatePagination(canIterate: canIterate)
                } else {
                    input?.updateProgress(isLoading: false)
                    input?.updateError(SampleError.sample)
                }
            }
        }
    }

}
