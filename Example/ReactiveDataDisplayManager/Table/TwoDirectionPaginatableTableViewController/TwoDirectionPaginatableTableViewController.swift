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
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
        static let paginatorViewHeight: CGFloat = 80
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var forwardProgressView = PaginatorView(frame: .init(x: 0,
                                                                      y: 0,
                                                                      width: tableView.frame.width,
                                                                      height: Constants.paginatorViewHeight))
    private lazy var backwardProgressView = PaginatorView(frame: .init(x: 0,
                                                                       y: 0,
                                                                       width: tableView.frame.width,
                                                                       height: Constants.paginatorViewHeight))

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .paginatable(progressView: forwardProgressView,
                                  output: self))
        .add(plugin: .backwardPaginatable(progressView: backwardProgressView,
                                  output: self))
        .build()

    private weak var forwardPaginatableInput: PaginatableInput?
    private weak var backwardPaginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentPage = 0

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
        adapter.addSectionHeaderGenerator(sectionHeader)

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    func makeGenerator() -> TableCellGenerator {
        TitleTableViewCell.rddm.calculatableHeightGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
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

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator()
        }

        adapter.insertAtEnd(to: sectionHeader, new: generators, with: .bottom)

        return currentPage != 0
    }

    func fillPrev() -> Bool {
        currentPage -= 1

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator()
        }

        adapter.insertAtBeginning(to: sectionHeader, new: generators, with: nil)

        return currentPage != 0
    }

}

// MARK: - PaginatableOutput

extension TwoDirectionPaginatableTableViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        forwardPaginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self, weak input] in
            let canFillPages = self?.canFillPages() ?? false

            if canFillPages {
                let canIterate = self?.fillNext() ?? false

                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
                self?.backwardPaginatableInput?.updatePagination(canIterate: canIterate)
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}

// MARK: - BackwardPaginatableOutput

extension TwoDirectionPaginatableTableViewController: BackwardPaginatableOutput {

    func onBackwardPaginationInitialized(with input: PaginatableInput) {
        backwardPaginatableInput = input
    }

    func loadPrevPage(with input: PaginatableInput) {
        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self, weak input] in
            guard let self = self else {
                return
            }
            if self.canFillPages() {
                let initialGeneratorsHeight = self.adapter.sections.first?.generators.reduce(0) {
                    return ($0 + $1.cellHeight)
                }

                let canIterate = self.fillPrev()
                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
                self.forwardPaginatableInput?.updatePagination(canIterate: canIterate)

                let newGeneratorsHeight = self.adapter.sections.first?.generators.reduce(0) {
                    print($1.cellHeight)
                    return ($0 + $1.cellHeight)
                }

                if let initialGeneratorsHeight = initialGeneratorsHeight, let newGeneratorsHeight = newGeneratorsHeight {
                    let finalOffset = CGPoint(x: 0, y: newGeneratorsHeight - initialGeneratorsHeight)
                    self.tableView.setContentOffset(finalOffset, animated: false)
                }
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}
