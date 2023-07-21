//
//  DynamicHeightCollectionViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class DynamicHeightViewController: UIViewController {

    // MARK: - @IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension DynamicHeightViewController {

    func fillAdapter() {
        adapter.addCellGenerator(DynamicHeightTableViewCell.rddm.nonReusableGenerator(with: ()))
        adapter.forceRefill()
        tableView.layoutIfNeeded()
    }

}
