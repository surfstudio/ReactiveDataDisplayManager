//
//  MainSPMTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Владислав Янковенко on 10.03.2021.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MainSPMTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models: [TableCellGenerator] = [
            BaseCellGenerator<SPMExampleTableViewCell>(with: "BaseCellGenerator"),
            SPMCustomTableGenerator(with: "Swipable")
        ]
        static let headers: [TableHeaderGenerator] = [
            TitleHeaderGenerator(model: "SectionHeader"),
            SectionTitleHeaderGenerator(model: "SectionTitleHeader", needSectionIndexTitle: true)
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
        let generator = BaseNonReusableCellGenerator<SPMExampleTableViewCell>(with: "BaseNonReusableCellGenerator")
        generator.update(model: "BaseNonReusableCellGenerator")

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
