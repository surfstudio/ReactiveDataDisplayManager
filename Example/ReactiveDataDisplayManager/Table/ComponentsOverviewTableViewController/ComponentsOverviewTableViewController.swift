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
        .build()

    private let sentMessageTimeStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let sentMessageTimeLayout = TextLayout(alignment: .left, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentMessageTimeModel = Model(text: .string("17:05"),
                                                  style: sentMessageTimeStyle,
                                                  layout: sentMessageTimeLayout,
                                                  edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: sentMessageTimeModel, and: .class)

    private let recievedTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let recievedTimeMessageLayout = TextLayout(alignment: .right, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedTimeMessageModel = Model(text: .string("17:32"),
                                                      style: recievedTimeMessageStyle,
                                                      layout: recievedTimeMessageLayout,
                                                      edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: recievedTimeMessageModel, and: .class)

    private let dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
    private let dateLayout = TextLayout(alignment: .center, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel = Model(text: .string("24 мая 2023"),
                                       style: dateStyle,
                                       layout: dateLayout,
                                       edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    private lazy var dateGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: dateModel, and: .class)

    private let sentMessageStyle = TextStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private let sentMessageLayout = TextLayout(alignment: .left, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentMessageModel: LabelView.Model = .init(text: .string("Lorem ipsum dolor sit amet"),
                                                               style: sentMessageStyle,
                                                               layout: sentMessageLayout,
                                                               edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var sentMessageGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: sentMessageModel, and: .class)

    private let recievedMessageStyle = TextStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private let recievedMessageLayout = TextLayout(alignment: .right, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedMessageModel = Model(text: .string("Lorem ipsum dolor sit amet"),
                                                  style: recievedMessageStyle,
                                                  layout: recievedMessageLayout,
                                                  edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var recievedMessageGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: recievedMessageModel, and: .class)

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
            generateSentMessages()
            sentMessageTimeGenerator
            generateRecievedMessages()
            recievedMessageTimeGenerator
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

    func generateSentMessages() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()
        for _ in 0...3 {
            generators.append(sentMessageGenerator)
        }
        return generators
    }

    func generateRecievedMessages() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()
        for _ in 0...3 {
            generators.append(recievedMessageGenerator)
        }
        return generators
    }

}
