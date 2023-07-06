//
//  VerticalStackTableCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Cell - container with vertical layout. Accepts generators of other cells, creates a single press state for them
open class VerticalStackTableCell: UITableViewCell, ConfigurableItem, ExpandableItem {

    // MARK: - Properties

    public private(set) var stackView = UIStackView()

    // MARK: - Private properties

    private let tableView = UITableView(frame: UIScreen.main.bounds)
    private lazy var ddm = tableView.rddm.baseBuilder.build()

    // MARK: - ExpandableItem

    public var onHeightChanged = ReactiveDataDisplayManager.BaseEvent<CGFloat?>()
    public var animatedExpandable = true

    // MARK: - Initialization

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupStackView()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(with generators: [TableCellGenerator]) {
        stackView.removeAllArrangedSubviews()
        ddm.sections.removeAll()
        ddm.addCellGenerators(generators)
        ddm.forceRefill()

        let views = tableView.visibleCells.map { cell in
            cell.contentView
        }
        views.forEach { view in
            self.stackView.addArrangedSubview(view)
        }
        self.onHeightChanged.invoke(with: nil)
    }

}

// MARK: - Private methods

private extension VerticalStackTableCell {

    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}
