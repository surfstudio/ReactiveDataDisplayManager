//
//  MainSPMTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Владислав Янковенко on 10.03.2021.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

/// This class is for displaying data only
/// The examples of Spm support located in:
/// - headers: `SPMHeaderTableView.swift`, `SPMHeaderTableGenerator.swift`
/// - cells: `SPMTableViewCell.swift`
/// For correct work, you must specify your SPM module for all `.xib` files and `.storyboard`
/// In all descendants of an `ConfigurableItem`, you must use the static method `bundle()` and return `Bundle.module`
/// In all views related to `.xib`, you also need to specify `Bundle.module`
final class MainSPMTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models: [TableCellGenerator] = [
            BaseCellGenerator<SPMTableViewCell>(with: "BaseCellGenerator"),
            SPMTableGenerator(with: "Swipable")
        ]
        static let headers: [TableHeaderGenerator] = [
            SPMHeaderTableGenerator(model: "SectionHeader")
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.manualBuilder
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private methods

private extension MainSPMTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        let generator = SPMTableViewCell.rddm.nonReusableGenerator(with: "BaseNonReusableCellGenerator")

        ddm.addCellGenerator(generator)
        Constants.models.forEach { (generator) in
            ddm.addCellGenerator(generator)
        }

        Constants.headers.forEach { (header) in
            ddm.addSectionHeaderGenerator(header)
        }

        ddm.forceRefill()
    }

}
