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
    private lazy var recievedMessageTimeModel: LabelView.Model = .build {
        LabelProperty.text(.string("17:05"))
        LabelProperty.style(recievedMessageTimeStyle)
        LabelProperty.layout(recievedMessageTimeLayout)
        LabelProperty.textAlignment(.left)
        LabelProperty.alignment(.leading(UIEdgeInsets(top: 12,
                                                      left: 16,
                                                      bottom: 12,
                                                      right: 0)))
    }

    private lazy var recievedMessageTimeGenerator = LabelView.rddm.tableGenerator(with: recievedMessageTimeModel, and: .class)

    // Sent message time
    private let sentTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
    private let sentTimeMessageLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentTimeMessageModel: LabelView.Model = .build {
        LabelProperty.text(.string("17:32"))
        LabelProperty.style(sentTimeMessageStyle)
        LabelProperty.layout(sentTimeMessageLayout)
        LabelProperty.textAlignment(.right)
        LabelProperty.alignment(.trailing(UIEdgeInsets(top: 12,
                                                       left: 0,
                                                       bottom: 12,
                                                       right: 16)))
    }

    private lazy var sentMessageTimeGenerator = LabelView.rddm.tableGenerator(with: sentTimeMessageModel, and: .class)

    // Date
    private let dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
    private let dateLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel: LabelView.Model = .build {
        LabelProperty.text(.string("24 мая 2023"))
        LabelProperty.style(dateStyle)
        LabelProperty.layout(dateLayout)
        LabelProperty.textAlignment(.center)
        LabelProperty.alignment(.all(UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 12,
                                                  right: 0)))
    }

    private lazy var dateGenerator = LabelView.rddm.tableGenerator(with: dateModel, and: .class)

    // Sent message
    private let sentMessageStyle = TextStyle(color: .white,
                                             font: .systemFont(ofSize: 16, weight: .regular))
    private let sentMessageBorderStyle = BorderStyle(cornerRadius: 9,
                                                            maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])
    private lazy var sentMessageModel: MessageView.Model = .build {
        if Bool.random() {
            MessageProperty.background(.solid(.systemBlue))
        } else {
            MessageProperty.background(.solid(.rddm))
        }
        MessageProperty.border(sentMessageBorderStyle)
        MessageProperty.style(sentMessageStyle)
        MessageProperty.textAlignment(.right)
        MessageProperty.alignment(.trailing(UIEdgeInsets(top: 12,
                                                         left: UIScreen.main.bounds.width / 2,
                                                         bottom: 12,
                                                         right: 16)
        ))
        MessageProperty.insets(UIEdgeInsets(top: 3,
                                            left: 5,
                                            bottom: 3,
                                            right: 5))
        MessageProperty.text(.string("Lorem"))
    }

    private lazy var sentMessageGenerator = MessageView.rddm.tableGenerator(with: sentMessageModel, and: .class)

    // Recieved message
    private let recievedMessageStyle = TextStyle(color: .black, font: .systemFont(ofSize: 16, weight: .regular))
    private let recievedMessageBorderStyle = BorderStyle(cornerRadius: 9,
                                                                maskedCorners: [
                                                                    .layerMinXMinYCorner,
                                                                    .layerMaxXMaxYCorner,
                                                                    .layerMaxXMinYCorner
                                                                ],
                                                                borderWidth: 1,
                                                                borderColor: UIColor.black.cgColor)
    private lazy var recievedMessageModel: MessageView.Model = .build {
        MessageProperty.border(recievedMessageBorderStyle)
        MessageProperty.style(recievedMessageStyle)
        MessageProperty.alignment(.leading(UIEdgeInsets(top: 12,
                                                        left: 16,
                                                        bottom: 12,
                                                        right: UIScreen.main.bounds.width / 2)))
        MessageProperty.insets(UIEdgeInsets(top: 3,
                                            left: 5,
                                            bottom: 3,
                                            right: 5))
        MessageProperty.text(.string("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet"))
    }

    private lazy var recievedMessageGenerator = MessageView.rddm.tableGenerator(with: recievedMessageModel, and: .class)

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
