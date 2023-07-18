//
//  SectionTitleTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SectionTitleTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let headerModels = [
            (title: "Section 1", needDisplaySectionTitle: true),
            (title: "Section 2", needDisplaySectionTitle: false),
            (title: "Section 3", needDisplaySectionTitle: false),
            (title: "Section 4", needDisplaySectionTitle: true),
            (title: "Section 5", needDisplaySectionTitle: false),
            (title: "Section 6", needDisplaySectionTitle: true),
            (title: "Section 7", needDisplaySectionTitle: false),
            (title: "Section 8", needDisplaySectionTitle: false),
            (title: "Section 9", needDisplaySectionTitle: false),
            (title: "Section 10", needDisplaySectionTitle: false),
            (title: "Section 11", needDisplaySectionTitle: true),
            (title: "Section 12", needDisplaySectionTitle: false)
        ]
        static let сellModels = [String](repeating: "Cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .sectionTitleDisplayable())
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "section title"
        fillAdapter()
    }

}

// MARK: - Private methods

private extension SectionTitleTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        Constants.headerModels.forEach {
            // Create header generator
            let headerGenerator = SectionTitleHeaderGenerator(model: $0.title, needSectionIndexTitle: $0.needDisplaySectionTitle)
            // Add header generator into adapter
            adapter.addSectionHeaderGenerator(headerGenerator)
            // Create footer generator
            let footerGenerator = SectionTitleFooterGenerator(model: $0.title)
            // Add footer generator into adapter
            adapter.addSectionFooterGenerator(footerGenerator)
            // Add cell generators into adapter
            adapter.addCellGenerators(makeCellGenerators())
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    // Make cells generators
    func makeCellGenerators() -> [TableCellGenerator] {
        return Constants.сellModels.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }
    }

}
