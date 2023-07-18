//
//  DragAndDroppableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class DragAndDroppableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForSectionFirst = "SectionFirst"
        static let titleForSectionLast = "SectionLast"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private var draggableParameters: DragablePreviewParameters {
        let params = UIDragPreviewParameters()
        params.visiblePath = UIBezierPath(ovalIn: .init(x: 10, y: 0, width: 80, height: 40))
        return .init(parameters: params)
    }

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .dragAndDroppable(draggableParameters: draggableParameters))
        .add(plugin: .selectable())
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "drag'n'drop cell"

        tableView.accessibilityIdentifier = "Table_with_drag_n_drop_cell"
        tableView.dragInteractionEnabled = true
        tableView.allowsMultipleSelection = true

        fillAdapter()
    }

}

// MARK: - Private methods

private extension DragAndDroppableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generators to adapter
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSectionFirst))
        adapter.addCellGenerators(makeCellGenerators(for: Array(1...10)))
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSectionLast))
        adapter.addCellGenerators(makeCellGenerators(for: Array(11...20)))

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// Create cells generators for range
    func makeCellGenerators(for range: [Int]) -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()

        for index in range {
            let generator = DragAndDroppableCellGenerator(with: "Cell: \(index)")
            generator.isNeedDeselect = false
            generators.append(generator)
        }

        return generators
    }

}
