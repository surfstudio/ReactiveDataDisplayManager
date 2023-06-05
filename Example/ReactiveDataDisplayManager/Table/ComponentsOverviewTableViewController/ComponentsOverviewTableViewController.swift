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
    private typealias MessageBorderStyle = MessageView.Model.BorderStyle
    private typealias SeparatorModel = SeparatorView.Model

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
    private let recievedMessageTimeLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedMessageTimeModel = LabelModel(text: .string("17:05"),
                                                           style: recievedMessageTimeStyle,
                                                           layout: recievedMessageTimeLayout,
                                                           textAlignment: .left,
                                                           edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0),
                                                           externalAlignment: .leading)
    private lazy var recievedMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: recievedMessageTimeModel, and: .class)

    // Sent message time
    private let sentTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let sentTimeMessageLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentTimeMessageModel = LabelModel(text: .string("17:32"),
                                                       style: sentTimeMessageStyle,
                                                       layout: sentTimeMessageLayout,
                                                       textAlignment: .right,
                                                       edgeInsets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16),
                                                       externalAlignment: .trailing)
    private lazy var sentMessageTimeGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: sentTimeMessageModel, and: .class)

    // Date
    private let dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
    private let dateLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel = LabelModel(text: .string("24 мая 2023"),
                                            style: dateStyle,
                                            layout: dateLayout,
                                            textAlignment: .center,
                                            edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    private lazy var dateGenerator = TableWrappedCell<LabelView>.rddm.baseGenerator(with: dateModel, and: .class)

    // Sent message
    private let sentMessageStyle = MessageStyle(textColor: .white,
                                                font: .systemFont(ofSize: 16, weight: .regular),
                                                backgroundColor: .systemBlue)
    private let sentMessageBorderStyle = MessageBorderStyle(cornerRadius: 9,
                                                            maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])
    private lazy var sentMessageModel: MessageModel = .init(text: .string("Lorem"),
                                                            style: sentMessageStyle,
                                                            textAlignment: .right,
                                                            externalAlignment: .trailing,
                                                            externalEdgeInsets: UIEdgeInsets(top: 12,
                                                                                             left: UIScreen.main.bounds.width / 2,
                                                                                             bottom: 12,
                                                                                             right: 16),
                                                            internalEdgeInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5),
                                                            borderStyle: sentMessageBorderStyle)

    private lazy var sentMessageGenerator = TableWrappedCell<MessageView>.rddm.baseGenerator(with: sentMessageModel, and: .class)

    // Recieved message
    private let recievedMessageStyle = MessageStyle(textColor: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private let recievedMessageBorderStyle = MessageBorderStyle(cornerRadius: 9,
                                                                maskedCorners: [.layerMinXMinYCorner,
                                                                                .layerMaxXMaxYCorner,
                                                                                .layerMaxXMinYCorner],
                                                                borderWidth: 1,
                                                                borderColor: UIColor.black.cgColor)
    private lazy var recievedMessageModel = MessageModel(text: .string("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet"),
                                                         style: recievedMessageStyle,
                                                         textAlignment: .left,
                                                         externalAlignment: .leading,
                                                         externalEdgeInsets: UIEdgeInsets(top: 12,
                                                                                          left: 16,
                                                                                          bottom: 12,
                                                                                          right: UIScreen.main.bounds.width / 2),
                                                         internalEdgeInsets: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5),
                                                         borderStyle: recievedMessageBorderStyle)
    private lazy var recievedMessageGenerator = TableWrappedCell<MessageView>.rddm.baseGenerator(with: recievedMessageModel, and: .class)

    // Separator

    private let separatorModel = SeparatorModel(height: 1, color: .lightGray, edgeInsets: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32))
    private lazy var separatorGenerator = TableWrappedCell<SeparatorView>.rddm.baseGenerator(with: separatorModel, and: .class)

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
            separatorGenerator
            generateRecievedMessages()
            recievedMessageTimeGenerator
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

    func generateSentMessages() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()
        for _ in 0..<20 {
            generators.append(sentMessageGenerator)
        }
        return generators
    }

    func generateRecievedMessages() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()
        for _ in 0..<30 {
            generators.append(recievedMessageGenerator)
        }
        return generators
    }

}
