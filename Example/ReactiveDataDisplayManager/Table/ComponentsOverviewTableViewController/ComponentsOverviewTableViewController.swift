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

    private lazy var recievedMessageTimeGenerator = LabelView.rddm.tableGenerator(with: recievedMessageTimeModel, and: .class)

    // Sent message time
    private let sentTimeMessageStyle = TextStyle(color: .gray, font: .systemFont(ofSize: 12, weight: .light))
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

    private lazy var sentMessageTimeGenerator = LabelView.rddm.tableGenerator(with: sentTimeMessageModel, and: .class)

    // Date
    private let dateStyle = TextStyle(color: .black, font: .systemFont(ofSize: 12, weight: .light))
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

    private lazy var dateGenerator = LabelView.rddm.tableGenerator(with: dateModel, and: .class)

    // Sent message
    private let sentMessageStyle = TextStyle(color: .white,
                                             font: .systemFont(ofSize: 16, weight: .regular))
    private let sentMessageBorderStyle = BorderStyle(cornerRadius: 9,
                                                     maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])
    private lazy var sentMessageModel: MessageView.Model = .build { property in
        if Bool.random() {
            property.background(.solid(.systemBlue))
        } else {
            property.background(.solid(.rddm))
        }
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
        property.text(.string("Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet"))

        let tapAction: () -> Void = {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                let alertController = UIAlertController(title: "MessageView Tapped", message: "The MessageView was tapped!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                topController.present(alertController, animated: true, completion: nil)
            }
        }
        property.tapHandler(TapHandler(id: "Handling tap on message",
                                       textStyle: TextStyle(color: .random),
                                       backgroundStyle: BackgroundStyle.solid(.random),
                                       tapAction: tapAction))

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
    let dataDetectionHandler: DataDetection.DataDetectionHandler = { urlString in
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    private lazy var dataDetection = DataDetection(id: "Highlighting links and open them by tap",
                                                   linkTextAttributes: [.foregroundColor: UIColor.blue],
                                                   dataDetectionHandler: dataDetectionHandler,
                                                   dataDetectorTypes: [.link])
    private lazy var recievedMessageModel: MessageView.Model = .build { property in
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
        property.text(.string("Check out link: https://stackoverflow.com/"))
        property.dataDetection(dataDetection)
        property.selectable(true)
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
