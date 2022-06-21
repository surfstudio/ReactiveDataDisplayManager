// Generated using Sourcery 1.8.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import ReactiveDataDisplayManager











class CollectionCellGeneratorMock: CollectionCellGenerator {
    var identifier: String {
        get { return underlyingIdentifier }
        set(value) { underlyingIdentifier = value }
    }
    var underlyingIdentifier: String!

    //MARK: - generate

    var generateCollectionViewForCallsCount = 0
    var generateCollectionViewForCalled: Bool {
        return generateCollectionViewForCallsCount > 0
    }
    var generateCollectionViewForReceivedArguments: (collectionView: UICollectionView, indexPath: IndexPath)?
    var generateCollectionViewForReceivedInvocations: [(collectionView: UICollectionView, indexPath: IndexPath)] = []
    var generateCollectionViewForReturnValue: UICollectionViewCell!
    var generateCollectionViewForClosure: ((UICollectionView, IndexPath) -> UICollectionViewCell)?

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        generateCollectionViewForCallsCount += 1
        generateCollectionViewForReceivedArguments = (collectionView: collectionView, indexPath: indexPath)
        generateCollectionViewForReceivedInvocations.append((collectionView: collectionView, indexPath: indexPath))
        if let generateCollectionViewForClosure = generateCollectionViewForClosure {
            return generateCollectionViewForClosure(collectionView, indexPath)
        } else {
            return generateCollectionViewForReturnValue
        }
    }

    //MARK: - registerCell

    var registerCellInCallsCount = 0
    var registerCellInCalled: Bool {
        return registerCellInCallsCount > 0
    }
    var registerCellInReceivedCollectionView: UICollectionView?
    var registerCellInReceivedInvocations: [UICollectionView] = []
    var registerCellInClosure: ((UICollectionView) -> Void)?

    func registerCell(in collectionView: UICollectionView) {
        registerCellInCallsCount += 1
        registerCellInReceivedCollectionView = collectionView
        registerCellInReceivedInvocations.append(collectionView)
        registerCellInClosure?(collectionView)
    }

    //MARK: - bundle

    var bundleCallsCount = 0
    var bundleCalled: Bool {
        return bundleCallsCount > 0
    }
    var bundleReturnValue: Bundle?
    var bundleClosure: (() -> Bundle?)?

    func bundle() -> Bundle? {
        bundleCallsCount += 1
        if let bundleClosure = bundleClosure {
            return bundleClosure()
        } else {
            return bundleReturnValue
        }
    }

}
class CollectionFoldableItemMock: CollectionFoldableItem {
    var didFoldEvent: BaseEvent<Bool> {
        get { return underlyingDidFoldEvent }
        set(value) { underlyingDidFoldEvent = value }
    }
    var underlyingDidFoldEvent: BaseEvent<Bool>!
    var isExpanded: Bool {
        get { return underlyingIsExpanded }
        set(value) { underlyingIsExpanded = value }
    }
    var underlyingIsExpanded: Bool!
    var childGenerators: [CollectionCellGenerator] = []

}
class CollectionFooterGeneratorMock: CollectionFooterGenerator {
    var identifier: UICollectionReusableView.Type {
        get { return underlyingIdentifier }
        set(value) { underlyingIdentifier = value }
    }
    var underlyingIdentifier: UICollectionReusableView.Type!

    //MARK: - generate

    var generateCollectionViewForCallsCount = 0
    var generateCollectionViewForCalled: Bool {
        return generateCollectionViewForCallsCount > 0
    }
    var generateCollectionViewForReceivedArguments: (collectionView: UICollectionView, indexPath: IndexPath)?
    var generateCollectionViewForReceivedInvocations: [(collectionView: UICollectionView, indexPath: IndexPath)] = []
    var generateCollectionViewForReturnValue: UICollectionReusableView!
    var generateCollectionViewForClosure: ((UICollectionView, IndexPath) -> UICollectionReusableView)?

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        generateCollectionViewForCallsCount += 1
        generateCollectionViewForReceivedArguments = (collectionView: collectionView, indexPath: indexPath)
        generateCollectionViewForReceivedInvocations.append((collectionView: collectionView, indexPath: indexPath))
        if let generateCollectionViewForClosure = generateCollectionViewForClosure {
            return generateCollectionViewForClosure(collectionView, indexPath)
        } else {
            return generateCollectionViewForReturnValue
        }
    }

    //MARK: - registerFooter

    var registerFooterInCallsCount = 0
    var registerFooterInCalled: Bool {
        return registerFooterInCallsCount > 0
    }
    var registerFooterInReceivedCollectionView: UICollectionView?
    var registerFooterInReceivedInvocations: [UICollectionView] = []
    var registerFooterInClosure: ((UICollectionView) -> Void)?

    func registerFooter(in collectionView: UICollectionView) {
        registerFooterInCallsCount += 1
        registerFooterInReceivedCollectionView = collectionView
        registerFooterInReceivedInvocations.append(collectionView)
        registerFooterInClosure?(collectionView)
    }

    //MARK: - size

    var sizeForSectionCallsCount = 0
    var sizeForSectionCalled: Bool {
        return sizeForSectionCallsCount > 0
    }
    var sizeForSectionReceivedArguments: (collectionView: UICollectionView, section: Int)?
    var sizeForSectionReceivedInvocations: [(collectionView: UICollectionView, section: Int)] = []
    var sizeForSectionReturnValue: CGSize!
    var sizeForSectionClosure: ((UICollectionView, Int) -> CGSize)?

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        sizeForSectionCallsCount += 1
        sizeForSectionReceivedArguments = (collectionView: collectionView, section: section)
        sizeForSectionReceivedInvocations.append((collectionView: collectionView, section: section))
        if let sizeForSectionClosure = sizeForSectionClosure {
            return sizeForSectionClosure(collectionView, section)
        } else {
            return sizeForSectionReturnValue
        }
    }

}
class CollectionHeaderGeneratorMock: CollectionHeaderGenerator {
    var identifier: UICollectionReusableView.Type {
        get { return underlyingIdentifier }
        set(value) { underlyingIdentifier = value }
    }
    var underlyingIdentifier: UICollectionReusableView.Type!

    //MARK: - generate

    var generateCollectionViewForCallsCount = 0
    var generateCollectionViewForCalled: Bool {
        return generateCollectionViewForCallsCount > 0
    }
    var generateCollectionViewForReceivedArguments: (collectionView: UICollectionView, indexPath: IndexPath)?
    var generateCollectionViewForReceivedInvocations: [(collectionView: UICollectionView, indexPath: IndexPath)] = []
    var generateCollectionViewForReturnValue: UICollectionReusableView!
    var generateCollectionViewForClosure: ((UICollectionView, IndexPath) -> UICollectionReusableView)?

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        generateCollectionViewForCallsCount += 1
        generateCollectionViewForReceivedArguments = (collectionView: collectionView, indexPath: indexPath)
        generateCollectionViewForReceivedInvocations.append((collectionView: collectionView, indexPath: indexPath))
        if let generateCollectionViewForClosure = generateCollectionViewForClosure {
            return generateCollectionViewForClosure(collectionView, indexPath)
        } else {
            return generateCollectionViewForReturnValue
        }
    }

    //MARK: - registerHeader

    var registerHeaderInCallsCount = 0
    var registerHeaderInCalled: Bool {
        return registerHeaderInCallsCount > 0
    }
    var registerHeaderInReceivedCollectionView: UICollectionView?
    var registerHeaderInReceivedInvocations: [UICollectionView] = []
    var registerHeaderInClosure: ((UICollectionView) -> Void)?

    func registerHeader(in collectionView: UICollectionView) {
        registerHeaderInCallsCount += 1
        registerHeaderInReceivedCollectionView = collectionView
        registerHeaderInReceivedInvocations.append(collectionView)
        registerHeaderInClosure?(collectionView)
    }

    //MARK: - size

    var sizeForSectionCallsCount = 0
    var sizeForSectionCalled: Bool {
        return sizeForSectionCallsCount > 0
    }
    var sizeForSectionReceivedArguments: (collectionView: UICollectionView, section: Int)?
    var sizeForSectionReceivedInvocations: [(collectionView: UICollectionView, section: Int)] = []
    var sizeForSectionReturnValue: CGSize!
    var sizeForSectionClosure: ((UICollectionView, Int) -> CGSize)?

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        sizeForSectionCallsCount += 1
        sizeForSectionReceivedArguments = (collectionView: collectionView, section: section)
        sizeForSectionReceivedInvocations.append((collectionView: collectionView, section: section))
        if let sizeForSectionClosure = sizeForSectionClosure {
            return sizeForSectionClosure(collectionView, section)
        } else {
            return sizeForSectionReturnValue
        }
    }

    //MARK: - bundle

    var bundleCallsCount = 0
    var bundleCalled: Bool {
        return bundleCallsCount > 0
    }
    var bundleReturnValue: Bundle?
    var bundleClosure: (() -> Bundle?)?

    func bundle() -> Bundle? {
        bundleCallsCount += 1
        if let bundleClosure = bundleClosure {
            return bundleClosure()
        } else {
            return bundleReturnValue
        }
    }

}

#if os(iOS)
class RefreshableInputMock: RefreshableInput {

    //MARK: - endRefreshing

    var endRefreshingCallsCount = 0
    var endRefreshingCalled: Bool {
        return endRefreshingCallsCount > 0
    }
    var endRefreshingClosure: (() -> Void)?

    func endRefreshing() {
        endRefreshingCallsCount += 1
        endRefreshingClosure?()
    }

}
class RefreshableOutputMock: RefreshableOutput {

    //MARK: - refreshContent

    var refreshContentWithCallsCount = 0
    var refreshContentWithCalled: Bool {
        return refreshContentWithCallsCount > 0
    }
    var refreshContentWithReceivedInput: RefreshableInput?
    var refreshContentWithReceivedInvocations: [RefreshableInput] = []
    var refreshContentWithClosure: ((RefreshableInput) -> Void)?

    func refreshContent(with input: RefreshableInput) {
        refreshContentWithCallsCount += 1
        refreshContentWithReceivedInput = input
        refreshContentWithReceivedInvocations.append(input)
        refreshContentWithClosure?(input)
    }

}
#endif

class StrategyDropableMock: StrategyDropable {

    //MARK: - canDrop

    var canDropFromToCallsCount = 0
    var canDropFromToCalled: Bool {
        return canDropFromToCallsCount > 0
    }
    var canDropFromToReceivedArguments: (source: IndexPath, destination: IndexPath)?
    var canDropFromToReceivedInvocations: [(source: IndexPath, destination: IndexPath)] = []
    var canDropFromToReturnValue: Bool!
    var canDropFromToClosure: ((IndexPath, IndexPath) -> Bool)?

    func canDrop(from source: IndexPath, to destination: IndexPath) -> Bool {
        canDropFromToCallsCount += 1
        canDropFromToReceivedArguments = (source: source, destination: destination)
        canDropFromToReceivedInvocations.append((source: source, destination: destination))
        if let canDropFromToClosure = canDropFromToClosure {
            return canDropFromToClosure(source, destination)
        } else {
            return canDropFromToReturnValue
        }
    }

}
class TableCellGeneratorMock: TableCellGenerator {
    var identifier: String {
        get { return underlyingIdentifier }
        set(value) { underlyingIdentifier = value }
    }
    var underlyingIdentifier: String!
    var cellHeight: CGFloat {
        get { return underlyingCellHeight }
        set(value) { underlyingCellHeight = value }
    }
    var underlyingCellHeight: CGFloat!
    var estimatedCellHeight: CGFloat?

    //MARK: - generate

    var generateTableViewForCallsCount = 0
    var generateTableViewForCalled: Bool {
        return generateTableViewForCallsCount > 0
    }
    var generateTableViewForReceivedArguments: (tableView: UITableView, indexPath: IndexPath)?
    var generateTableViewForReceivedInvocations: [(tableView: UITableView, indexPath: IndexPath)] = []
    var generateTableViewForReturnValue: UITableViewCell!
    var generateTableViewForClosure: ((UITableView, IndexPath) -> UITableViewCell)?

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        generateTableViewForCallsCount += 1
        generateTableViewForReceivedArguments = (tableView: tableView, indexPath: indexPath)
        generateTableViewForReceivedInvocations.append((tableView: tableView, indexPath: indexPath))
        if let generateTableViewForClosure = generateTableViewForClosure {
            return generateTableViewForClosure(tableView, indexPath)
        } else {
            return generateTableViewForReturnValue
        }
    }

    //MARK: - registerCell

    var registerCellInCallsCount = 0
    var registerCellInCalled: Bool {
        return registerCellInCallsCount > 0
    }
    var registerCellInReceivedTableView: UITableView?
    var registerCellInReceivedInvocations: [UITableView] = []
    var registerCellInClosure: ((UITableView) -> Void)?

    func registerCell(in tableView: UITableView) {
        registerCellInCallsCount += 1
        registerCellInReceivedTableView = tableView
        registerCellInReceivedInvocations.append(tableView)
        registerCellInClosure?(tableView)
    }

    //MARK: - bundle

    var bundleCallsCount = 0
    var bundleCalled: Bool {
        return bundleCallsCount > 0
    }
    var bundleReturnValue: Bundle?
    var bundleClosure: (() -> Bundle?)?

    func bundle() -> Bundle? {
        bundleCallsCount += 1
        if let bundleClosure = bundleClosure {
            return bundleClosure()
        } else {
            return bundleReturnValue
        }
    }

}
