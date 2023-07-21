//
//  StackCellExampleViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit
import ReactiveDataComponents
import ReactiveDataDisplayManager

final class StackCellExampleViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellVerticalCount = Array(1...10)
        static let cellHorizontalCount = Array(1...2)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .selectable())
        .add(plugin: .highlightable())
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack inside table"
        tableView.accessibilityIdentifier = "Stack_Cell_Example_View_Controller"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension StackCellExampleViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        // Add section into adapter
        adapter += Section(header: TitleHeaderGenerator(model: "TableVStack"), footer: EmptyTableFooterGenerator()) {
            TableVStack {
                TitleTableViewCell.buildView(with: "1")
                TitleTableViewCell.buildView(with: "2")
                TableHStack {
                    TitleTableViewCell.buildView(with: "4")
                    TitleTableViewCell.buildView(with: "5")
                }
                TitleTableViewCell.buildView(with: "3")
            }
            .didSelectEvent {
                print("VerticalTableStack did select event")
            }
        }

        // Note that using `UITableViewCell` or `UICollectionViewCell` inside stack is not recommended, but it possible
        adapter += TableSection(header: TitleHeaderGenerator(model: "StackView based cells"), footer: EmptyTableFooterGenerator()) {
            TableFactory.stack(model: .build { vStack in
                vStack.background(.solid(.rddm))
                vStack.style(.init(axis: .vertical,
                                   spacing: 8,
                                   alignment: .fill,
                                   distribution: .fill))
            }) { context in
                context.stack(model: .build { hStack in
                    hStack.background(.solid(.systemBlue))
                    hStack.style(.init(axis: .horizontal,
                                       spacing: 4,
                                       alignment: .fill,
                                       distribution: .fillEqually))
                }) { context in
                    context.viewNib(type: TitleTableViewCell.self, model: "4")
                    context.viewNib(type: TitleTableViewCell.self, model: "5")
                }
                context.viewNib(type: TitleTableViewCell.self, model: "3")
            }
            TableFactory.viewClass(type: LabelView.self, model: .build { label in
                label.textAlignment(.center)
                label.text(.string("Wrapped LabelView"))
                label.style(.init(color: .systemBlue, font: .systemFont(ofSize: 16)))
            })
            TableFactory.cell(type: TitleTableViewCell.self, model: "Cell outside from stack", registerType: .nib)
            TableFactory.stack(model: .build { hStack in
                hStack.background(.solid(.systemGreen))
                hStack.style(.init(axis: .horizontal,
                                   spacing: 0,
                                   alignment: .fill,
                                   distribution: .fillEqually))
            }) { context in
                context.viewNib(type: TitleTableViewCell.self, model: "6")
                context.stack(model: .build { vStack in
                    vStack.background(.solid(.systemPink))
                    vStack.style(.init(axis: .vertical,
                                       spacing: 20,
                                       alignment: .fill,
                                       distribution: .fillEqually))
                }) { context in
                    context.viewNib(type: TitleTableViewCell.self, model: "7")
                    context.viewNib(type: TitleTableViewCell.self, model: "8")
                    context.viewNib(type: TitleTableViewCell.self, model: "9")
                    context.viewNib(type: TitleTableViewCell.self, model: "10")
                }
            }
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
