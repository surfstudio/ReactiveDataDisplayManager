//
//  CustomizableComponentsTableViewController.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 24.05.2023.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

final class CustomizableComponentsTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForRegularCell = "Lorem ipsum dolor sit amet"
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .foldable())
        .build()

    private lazy var sentMessageTimeStyle: LabelView.TextStyle = (.gray, .systemFont(ofSize: 12, weight: .light))
    private lazy var sentMessageTimeLayout: LabelView.TextLayout = (.left, .byWordWrapping, 0)
    private lazy var sentMessageTimeModel: LabelView.Model = .init(text: "17:05",
                                                                   style: sentMessageTimeStyle,
                                                                   layout: sentMessageTimeLayout,
                                                                   edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageTimeGenerator = BaseCellGenerator<TableLabelCell>(with: sentMessageTimeModel, registerType: .class)

    private lazy var recievedTimeMessageStyle: LabelView.TextStyle = (.gray, .systemFont(ofSize: 12, weight: .light))
    private lazy var recievedTimeMessageLayout: LabelView.TextLayout = (.right, .byWordWrapping, 0)
    private lazy var recievedTimeMessageModel: LabelView.Model = .init(text: "17:32",
                                                                       style: recievedTimeMessageStyle,
                                                                       layout: recievedTimeMessageLayout,
                                                                       edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageTimeGenerator = BaseCellGenerator<TableLabelCell>(with: recievedTimeMessageModel, registerType: .class)

    private lazy var dateStyle: LabelView.TextStyle = (.black, .systemFont(ofSize: 12, weight: .light))
    private lazy var dateLayout: LabelView.TextLayout = (.center, .byWordWrapping, 0)
    private lazy var dateModel: LabelView.Model = .init(text: "24 мая 2023",
                                                        style: dateStyle,
                                                        layout: dateLayout,
                                                        edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    private lazy var dateGenerator = BaseCellGenerator<TableLabelCell>(with: dateModel, registerType: .class)

    private lazy var sentMessageStyle: LabelView.TextStyle = (.black, .systemFont(ofSize: 16, weight: .regular))
    private lazy var sentMessageLayout: LabelView.TextLayout = (.left, .byWordWrapping, 0)
    private lazy var sentMessageModel: LabelView.Model = .init(text: "Lorem ipsum dolor sit amet",
                                                               style: sentMessageStyle,
                                                               layout: sentMessageLayout,
                                                               edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageGenerator = BaseCellGenerator<TableLabelCell>(with: sentMessageModel, registerType: .class)

    private lazy var recievedMessageStyle: LabelView.TextStyle = (.black, .systemFont(ofSize: 16, weight: .regular))
    private lazy var recievedMessageLayout: LabelView.TextLayout = (.right, .byWordWrapping, 0)
    private lazy var recievedMessageModel: LabelView.Model = .init(text: "Lorem ipsum dolor sit amet",
                                                                   style: recievedMessageStyle,
                                                                   layout: recievedMessageLayout,
                                                                   edgeInsets:  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageGenerator = BaseCellGenerator<TableLabelCell>(with: recievedMessageModel, registerType: .class)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "CustomizableComponentsTableViewController"
        tableView.separatorStyle = .none
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension CustomizableComponentsTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        adapter += TableGenerators {
            dateGenerator
            sentMessageGenerator
            sentMessageGenerator
            sentMessageGenerator
            sentMessageTimeGenerator
            recievedMessageGenerator
            recievedMessageGenerator
            recievedMessageGenerator
            recievedMessageTimeGenerator
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
