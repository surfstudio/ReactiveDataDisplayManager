// 
//  TableController.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 27.07.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class TableController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(featurePlugin: .focusable(
            by: BorderFocusableStrategy(model: .init(color: .gray))
        ))
        .add(plugin: .selectable())
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private methods

private extension TableController {

    func fillAdapter() {
        for index in (0..<12) {
            // Create generator
            let canBeFocused = index < 2 || index > 5
            let generator = TitleTableViewGenerator(with: .init(title: "Row \(index)", canBeFocused: canBeFocused))

            generator.didSelectEvent += {
                print("Row \(index) was selected")
            }

            // Add generator to adapter
            ddm.addCellGenerator(generator)
        }

        ddm.forceRefill()
    }

}
