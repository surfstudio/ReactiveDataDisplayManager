//
//  ComponentsOverviewTableViewController.swift
//  ReactiveDataComponentsTests_iOS
//
//  Created by Антон Голубейков on 24.05.2023.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

final class ComponentsOverviewTableViewController: UIViewController {

    // MARK: - Nested types

    private typealias TextStyle = LabelView.Model.TextStyle
    private typealias TextLayout = LabelView.Model.TextLayout
    private typealias Model = LabelView.Model

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

    private lazy var sentMessageTimeStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private lazy var sentMessageTimeLayout = TextLayout(alignment: .left, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentMessageTimeModel = Model(text: .string("17:05"),
                                                  style: sentMessageTimeStyle,
                                                  layout: sentMessageTimeLayout,
                                                  edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageTimeGenerator = BaseCellGenerator<TableLabelCell>(with: sentMessageTimeModel, registerType: .class)

    private lazy var recievedTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private lazy var recievedTimeMessageLayout = TextLayout(alignment: .right, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedTimeMessageModel = Model(text: .string("17:32"),
                                                      style: recievedTimeMessageStyle,
                                                      layout: recievedTimeMessageLayout,
                                                      edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageTimeGenerator = BaseCellGenerator<TableLabelCell>(with: recievedTimeMessageModel, registerType: .class)

    private lazy var dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
    private lazy var dateLayout = TextLayout(alignment: .center, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel = Model(text: .string("24 мая 2023"),
                                       style: dateStyle,
                                       layout: dateLayout,
                                       edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    private lazy var dateGenerator = BaseCellGenerator<TableLabelCell>(with: dateModel, registerType: .class)

    private lazy var sentMessageStyle = TextStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private lazy var sentMessageLayout = TextLayout(alignment: .left, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentMessageModel: LabelView.Model = .init(text: .string("Lorem ipsum dolor sit amet"),
                                                               style: sentMessageStyle,
                                                               layout: sentMessageLayout,
                                                               edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageGenerator = BaseCellGenerator<TableLabelCell>(with: sentMessageModel, registerType: .class)

    private lazy var recievedMessageStyle = TextStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private lazy var recievedMessageLayout = TextLayout(alignment: .right, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedMessageModel = Model(text: .string("Lorem ipsum dolor sit amet"),
                                                  style: recievedMessageStyle,
                                                  layout: recievedMessageLayout,
                                                  edgeInsets:  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageGenerator = BaseCellGenerator<TableLabelCell>(with: recievedMessageModel, registerType: .class)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "ComponentsOverviewTableViewController"
        tableView.separatorStyle = .none
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension ComponentsOverviewTableViewController {

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
