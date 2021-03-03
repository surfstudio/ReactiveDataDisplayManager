//
//  PaginatableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class PaginatableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 16
        static let pagesCount = 3
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var progressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .paginatable(progressView: progressView,
                                  output: self))
        .build()

    private var currentPage = 0

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with pagination"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension PaginatableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        for _ in 0...Constants.pageSize {
            adapter.addCellGenerator(makeGenerator())
        }

        adapter.forceRefill()


    }

    func delay(_ deadline: DispatchTime, completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func makeGenerator() -> TableCellGenerator {
        TitleTableViewCell.rddm.baseGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
    }

    func fillNext() -> Bool {
        currentPage += 1

        for _ in 0...Constants.pageSize {
            adapter.addCellGenerator(makeGenerator())
        }

        adapter.forceRefill()

        return currentPage < Constants.pagesCount
    }

}


// MARK: - RefreshableOutput

extension PaginatableTableViewController: PaginatableOutput {

    func loadNextPage(with input: PaginatableInput) {
        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canIterate = self?.fillNext() ?? false

            input?.endLoading(canIterate: canIterate)
        }
    }

}
