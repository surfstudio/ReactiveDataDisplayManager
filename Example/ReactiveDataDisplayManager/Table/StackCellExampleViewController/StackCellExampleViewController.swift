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
        .add(plugin: .foldable())
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

        // Note that using `UITableViewCell` or `UICollectionViewCell` inside stack is not recommended, but it possible
        adapter += TableSection.create(header: TitleHeaderGenerator(model: "StackView based cells"),
                                       footer: EmptyTableFooterGenerator()) { ctx in
            StackView.build(in: ctx, with: .build { vStack in
                vStack.background(.solid(.rddm))
                vStack.style(.init(axis: .vertical,
                                   spacing: 8,
                                   alignment: .fill,
                                   distribution: .fill))
                vStack.children { ctx in
                    TitleTableViewCell.build(in: ctx, with: "1")
                    TitleTableViewCell.build(in: ctx, with: "2")
                    StackView.build(in: ctx, with: .build { hStack in
                        hStack.background(.solid(.systemBlue))
                        hStack.style(.init(axis: .horizontal,
                                           spacing: 4,
                                           alignment: .fill,
                                           distribution: .fillEqually))
                        hStack.children { ctx in
                            TitleTableViewCell.build(in: ctx, with: "4")
                            TitleTableViewCell.build(in: ctx, with: "5")
                        }
                    })
                    TitleTableViewCell.build(in: ctx, with: "3")
                }
            }).didSelectEvent {
                print("StackView did select")
            }
            LabelView.build(in: ctx, with: .build { label in
                label.textAlignment(.center)
                label.text(.string("Wrapped LabelView"))
                label.style(.init(color: .systemBlue, font: .preferredFont(forTextStyle: .body)))
            })
            TitleTableViewCell.build(in: ctx, with: "Cell outside from stack")
                .didSelectEvent {
                    print("Cell outside from stack did select")
                }
            StackView.build(in: ctx, with: .build { hStack in
                hStack.background(.solid(.systemGreen))
                hStack.style(.init(axis: .horizontal,
                                   spacing: 0,
                                   alignment: .fill,
                                   distribution: .fillEqually))
                hStack.children { ctx in
                    TitleTableViewCell.build(in: ctx, with: "6")
                    StackView.build(in: ctx, with: .build { vStack in
                        vStack.background(.solid(.systemPink))
                        vStack.style(.init(axis: .vertical,
                                           spacing: 20,
                                           alignment: .fill,
                                           distribution: .fillEqually))
                        vStack.children { ctx in
                            TitleTableViewCell.build(in: ctx, with: "7")
                            TitleTableViewCell.build(in: ctx, with: "8")
                            TitleTableViewCell.build(in: ctx, with: "9")
                            TitleTableViewCell.build(in: ctx, with: "10")
                        }
                    })
                }
            })
            FoldableTableViewCell.build(in: ctx, with: .init(title: "example", isExpanded: false))
                .asFoldable { ctx in
                    TitleTableViewCell.build(in: ctx, with: "first child")
                        .didSelectEvent {
                            print("first child did select")
                        }
                    TitleTableViewCell.build(in: ctx, with: "second child")
                        .didSelectEvent {
                            print("second child did select")
                        }
                }
                .animation((.bottom, .top))
                .didFoldEvent {
                    print("Foldable cell is \($0 ? "expanded" : "collapsed")")
                }
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
