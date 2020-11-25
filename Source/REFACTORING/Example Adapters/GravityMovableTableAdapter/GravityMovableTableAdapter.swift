////
////  GravityMovableTableAdapter.swift
////  ReactiveDataDisplayManager
////
////  Created by Aleksandr Smirnov on 24.11.2020.
////  Copyright © 2020 Александр Кравченков. All rights reserved.
////
//
//import Foundation
//
//open class GravityMovableTableAdapter: AbstractAdapter {
//
//    // MARK: - Typealiases
//
//    public typealias CollectionType = UITableView
//    public typealias CollectionStateManagerType = GravityTableStateManager
//    public typealias CollectionDelegateType = MovableTableDelegate
//    public typealias CollectionDataSourceType = BaseTableDataSource
//    public typealias CellGeneratorType = GravityTableCellGenerator
//    public typealias HeaderGeneratorType = GravityTableHeaderGenerator
//
//    /// Called if table scrolled
//    public var scrollEvent = BaseEvent<UITableView>()
//    public var scrollViewWillEndDraggingEvent: BaseEvent<CGPoint> = BaseEvent<CGPoint>()
//    public var cellChangedPosition = BaseEvent<(oldIndexPath: IndexPath, newIndexPath: IndexPath)>()
//
//    /// Celled when cells displaying
//    public var willDisplayCellEvent = BaseEvent<(TableCellGenerator, IndexPath)>()
//    public var didEndDisplayCellEvent = BaseEvent<(TableCellGenerator, IndexPath)>()
//
//    // MARK: - Private(set) Properties
//
//    public var collection: UITableView
//    public var stateManager: GravityTableStateManager
//
//    // MARK: - Private Properties
//
//    private var delegate: UITableViewDelegate?
//    private var dataSource: UITableViewDataSource?
//
//    // MARK: - Initialization
//
//    public required init(collection: UITableView,
//                         stateManager: GravityTableStateManager = GravityTableStateManager(),
//                         delegate: MovableTableDelegate = MovableTableDelegate(),
//                         dataSource: BaseTableDataSource = BaseTableDataSource()) {
//        self.collection = collection
//
//        self.stateManager = stateManager
//        self.stateManager.adapter = self
//
//        self.collection.delegate = delegate
//        delegate.adapter = self
//        self.delegate = delegate
//
//        self.collection.dataSource = dataSource
//        dataSource.adapter = self
//        self.dataSource = dataSource
//    }
//
//    public func forceRefill() {
//        self.stateManager.forceRefill()
//    }
//
//    public func forceRefill(completion: @escaping (() -> Void)) {
//        self.stateManager.forceRefill(completion: completion)
//    }
//
//    public func addCellGenerator(_ generator: GravityTableCellGenerator) {
//        self.stateManager.addCellGenerator(generator)
//    }
//
//    public func addCellGenerators(_ generators: [GravityTableCellGenerator], after: GravityTableCellGenerator) {
//        self.stateManager.addCellGenerators(generators, after: after)
//    }
//
//    public func addCellGenerator(_ generator: GravityTableCellGenerator, after: GravityTableCellGenerator) {
//        self.stateManager.addCellGenerator(generator, after: after)
//    }
//
//    public func addCellGenerators(_ generators: [GravityTableCellGenerator]) {
//        self.stateManager.addCellGenerators(generators)
//    }
//
//    public func update(generators: [GravityTableCellGenerator]) {
//        self.stateManager.update(generators: generators)
//    }
//
//    public func clearCellGenerators() {
//        self.stateManager.clearCellGenerators()
//    }
//
//}
