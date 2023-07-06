//
//  CollectionStack.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 30.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

open class CollectionStack: UIView, ConfigurableItem {

    // MARK: - Properties

    open var axis: NSLayoutConstraint.Axis {
        .vertical
    }

    // MARK: - Private properties

    private var views: [UIView] = []
    private var cell: StackCollectionCell?
    private let stackView = UIStackView()

    // MARK: - Initialization

    public init(space: CGFloat, insets: UIEdgeInsets, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        self.views = items().compactMap { item in
            return (item as? UICollectionViewCell)?.contentView
            ?? (item as? UITableViewCell)?.contentView
            ?? item
        }
        super.init(frame: .zero)
        setupStackView(with: space, insets: insets)
        configure(with: views)
        updateFrameByContent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func updateItems(_ items: [any ConfigurableItem]) {
        self.views = items.compactMap { item in
            return (item as? UICollectionViewCell)?.contentView ?? (item as? UITableViewCell)?.contentView
        }
        configure(with: views)
    }

    public func removeItem(_ item: any ConfigurableItem) {
        guard let view = (item as? UICollectionViewCell)?.contentView ?? (item as? UITableViewCell)?.contentView,
              let index = views.firstIndex(where: { $0 === view }) else {
            return
        }
        views.remove(at: index)
        configure(with: views)
    }

    public func configure(with model: [UIView]) {
        views = model
        cell?.configure(with: self)

        stackView.removeAllArrangedSubviews()
        // надо обновить все дочерние ячейки
        model.forEach { view in
            stackView.addArrangedSubview(view)
        }
        updateFrameByContent()
    }

    // MARK: - Private methods

    private func setupStackView(with spacing: CGFloat, insets: UIEdgeInsets) {
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.attach(
            to: self,
            topOffset: insets.top,
            bottomOffset: insets.bottom,
            leftOffset: insets.left,
            rightOffset: insets.right
        )
    }

}

// MARK: - TableCellGenerator

extension CollectionStack: CollectionCellGenerator {

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? StackCollectionCell else {
            return UICollectionViewCell()
        }
        self.cell = cell
        configure(with: views)
        return cell
    }

    public func registerCell(in collectionView: UICollectionView) {
        collectionView.register(StackCollectionCell.self, forCellWithReuseIdentifier: identifier)
    }

    public var identifier: String {
        return String(describing: StackCollectionCell.self)
    }

    public static func bundle() -> Bundle? {
        return .main
    }

}

public final class VerticalCollectionStack: CollectionStack {

    // MARK: - Public properties

    public override var axis: NSLayoutConstraint.Axis {
        .vertical
    }

    // MARK: - Initialization

    public override init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, items: items)
    }

    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: .zero, insets: .zero, items: items)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public final class HorizontalCollectionStack: CollectionStack {

    // MARK: - Public properties

    public override var axis: NSLayoutConstraint.Axis {
        .horizontal
    }

    // MARK: - Initialization

    public override init(space: CGFloat, insets: UIEdgeInsets = .zero, @ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: space, insets: insets, items: items)
    }

    public init(@ConfigurableItemBuilder items: () -> [any ConfigurableItem]) {
        super.init(space: 0, insets: .zero, items: items)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
