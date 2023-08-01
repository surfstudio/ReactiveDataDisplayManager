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

    private enum Messages: String, CaseIterable {
        case hi
        case hello
        case question = "Are you here?"
        case answer = "Yes, I'm here"
        case bye
        case long = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed nunc id nisl aliquet ultrices. Integer auctor, nisl euismod efficitur maximus, urna diam aliquam tellus, sed lacinia velit nibh eget sem. Nullam sed nisi eget nisl tincidunt malesuada. Donec euismod, turpis et tincidunt luctus, nisl nunc ultricies nunc, non aliquam velit magna id urna. Nullam vel nunc auctor, luctus urna in, aliquet libero. Donec euismod, turpis et tincidunt luctus, nisl nunc ultricies nunc, non aliquam velit magna id urna. Nullam vel nunc auctor, luctus urna in, aliquet libero."
        case link = "Check out link: https://stackoverflow.com"

        var preparedForSent: Bool {
            switch self {
            case .link, .hi, .answer:
                return false
            default:
                return true
            }
        }

        var preparedForReceived: Bool {
            switch self {
            case .hello, .question:
                return false
            default:
                return true
            }
        }

    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .accessibility())
        .build()

    // Recieved message time
    private let recievedMessageTimeStyle = TextStyle(color: .gray, font: .preferredFont(forTextStyle: .caption1))
    private let recievedMessageTimeLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var recievedMessageTimeModel: LabelView.Model = .build { property in
        property.text(.string("17:05"))
        property.style(recievedMessageTimeStyle)
        property.layout(recievedMessageTimeLayout)
        property.textAlignment(.left)
        property.alignment(.leading(UIEdgeInsets(top: 12,
                                                 left: 16,
                                                 bottom: 12,
                                                 right: 0)))
    }

    private lazy var recievedMessageTimeGenerator = LabelView.rddm.tableGenerator(with: recievedMessageTimeModel)

    // Sent message time
    private let sentTimeMessageStyle = TextStyle(color: .gray, font: .preferredFont(forTextStyle: .caption1))
    private let sentTimeMessageLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var sentTimeMessageModel: LabelView.Model = .build { property in
        property.text(.string("17:32"))
        property.style(sentTimeMessageStyle)
        property.layout(sentTimeMessageLayout)
        property.textAlignment(.right)
        property.alignment(.trailing(UIEdgeInsets(top: 12,
                                                  left: 0,
                                                  bottom: 12,
                                                  right: 16)))
    }

    private lazy var sentMessageTimeGenerator = LabelView.rddm.tableGenerator(with: sentTimeMessageModel)

    // Date
    private let dateStyle = TextStyle(color: .black, font: .preferredFont(forTextStyle: .caption1))
    private let dateLayout = TextLayout(lineBreakMode: .byWordWrapping, numberOfLines: 0)
    private lazy var dateModel: LabelView.Model = .build { property in
        property.text(.string("24 мая 2023"))
        property.style(dateStyle)
        property.layout(dateLayout)
        property.textAlignment(.center)
        property.alignment(.all(UIEdgeInsets(top: 0,
                                             left: 0,
                                             bottom: 12,
                                             right: 0)))
    }

    private lazy var dateGenerator = LabelView.rddm.tableGenerator(with: dateModel)

    // Sent message
    private let sentMessageStyle = TextStyle(color: .white,
                                             font: .preferredFont(forTextStyle: .body))
    private let sentMessageBorderStyle = BorderStyle(cornerRadius: 9,
                                                     maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])

    // Recieved message
    private let recievedMessageStyle = TextStyle(color: .black, font: .preferredFont(forTextStyle: .body))
    private let recievedMessageBorderStyle = BorderStyle(cornerRadius: 9,
                                                         maskedCorners: [
                                                            .layerMinXMinYCorner,
                                                            .layerMaxXMaxYCorner,
                                                            .layerMaxXMinYCorner
                                                         ],
                                                         borderWidth: 1,
                                                         borderColor: UIColor.black.cgColor)
    let dataDetectionHandler: DataDetectionStyle.Handler = { url in
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private lazy var dataDetection = DataDetectionStyle(id: "Basic handling of links using UIApplication",
                                                   linkTextAttributes: [.foregroundColor: UIColor.blue],
                                                   handler: dataDetectionHandler,
                                                   dataDetectorTypes: [.link])

    // Separator

    private let separatorModel = SeparatorModel(size: .height(1),
                                                color: .lightGray,
                                                edgeInsets: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32))
    private lazy var separatorGenerator = SeparatorView.rddm.tableGenerator(with: separatorModel)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "ComponentsOverviewTableViewController"
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
        Messages.allCases
            .filter { $0.preparedForSent }
            .map { $0.rawValue }
            .map { message in
                MessageView.rddm.tableGenerator(with: .build { property in
                    property.background(.solid(.rddm))
                    property.border(sentMessageBorderStyle)
                    property.style(sentMessageStyle)
                    property.textAlignment(.right)
                    property.alignment(.trailing(UIEdgeInsets(top: 12,
                                                              left: UIScreen.main.bounds.width / 2,
                                                              bottom: 12,
                                                              right: 16)
                    ))
                    property.insets(UIEdgeInsets(top: 3,
                                                 left: 5,
                                                 bottom: 3,
                                                 right: 5))
                    property.text(.string(message))
                })
            }
    }

    func generateRecievedMessages() -> [TableCellGenerator] {
        Messages.allCases
            .filter { $0.preparedForReceived }
            .map { $0.rawValue }
            .map { message in
                MessageView.rddm.tableGenerator(with: .build { property in
                    property.border(recievedMessageBorderStyle)
                    property.style(recievedMessageStyle)
                    property.alignment(.leading(UIEdgeInsets(top: 12,
                                                             left: 16,
                                                             bottom: 12,
                                                             right: UIScreen.main.bounds.width / 2)))
                    property.insets(UIEdgeInsets(top: 3,
                                                 left: 5,
                                                 bottom: 3,
                                                 right: 5))
                    property.dataDetection(dataDetection)
                    property.selectable(true)
                    property.text(.string(message))
                })
            }
    }

}
