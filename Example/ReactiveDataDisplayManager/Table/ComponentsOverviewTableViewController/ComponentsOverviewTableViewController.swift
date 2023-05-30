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
    private typealias LabelModel = LabelView.Model
    private typealias MessageModel = MessageView.Model
    private typealias MessageStyle = MessageView.Model.MessageStyle

    // MARK: - Constants

    private enum Constants {
        static let titleForRegularCell = "Lorem ipsum dolor sit amet"
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .build()

    // Recieved message time
    private let recievedMessageTimeStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let recievedMessageTimeLayout = TextLayout(alignment: .left, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedMessageTimeModel = LabelModel(text: .string("17:05"),
                                                  style: recievedMessageTimeStyle,
                                                  layout: recievedMessageTimeLayout,
                                                  edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
    private lazy var recievedMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: recievedMessageTimeModel, and: .class)

    // Sent message time
    private let sentTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let sentTimeMessageLayout = TextLayout(alignment: .right, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentTimeMessageModel = LabelModel(text: .string("17:32"),
                                                      style: sentTimeMessageStyle,
                                                      layout: sentTimeMessageLayout,
                                                      edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16))
    private lazy var sentMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: sentTimeMessageModel, and: .class)

    // Date
    private let dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
    private let dateLayout = TextLayout(alignment: .center, lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel = LabelModel(text: .string("24 мая 2023"),
                                       style: dateStyle,
                                       layout: dateLayout,
                                       edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    private lazy var dateGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: dateModel, and: .class)

    // Sent message
    private let sentMessageStyle = MessageStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private lazy var sentMessageModel: MessageModel = .init(text: "Lorem ipsum dolor sit amet",
                                                            style: sentMessageStyle,
                                                            textAlignment: .right,
                                                            externalEdgeInsets: UIEdgeInsets(top: 12, left: UIScreen.main.bounds.width / 2, bottom: 12, right: 16),
                                                            internalEdgeInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))

    private lazy var sentMessageGenerator = TableWrappedCell<MessageView>.rddm.baseGenerator(with: sentMessageModel, and: .class)

    // Recieved message
    private let recievedMessageStyle = MessageStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private lazy var recievedMessageModel = MessageModel(text: "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                                                         style: recievedMessageStyle,
                                                         textAlignment: .left,
                                                         externalEdgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: UIScreen.main.bounds.width / 2),
                                                         internalEdgeInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
    private lazy var recievedMessageGenerator = TableWrappedCell<MessageView>.rddm.baseGenerator(with: recievedMessageModel, and: .class)

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
        for _ in 0..<3 {
            generators.append(recievedMessageGenerator)
        }
        return generators
    }

}
