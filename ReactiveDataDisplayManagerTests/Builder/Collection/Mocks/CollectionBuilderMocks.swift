//
//  CollectionBuilderMocks.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//
import UIKit

@testable import ReactiveDataDisplayManager

final class PaginatableOutputMock: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) { }

    func loadNextPage(with input: PaginatableInput) { }

}

final class ProgressViewMock: UIView, ProgressDisplayableItem {

    func showProgress(_ isLoading: Bool) { }

}

final class CollectionScrollProviderMock: CollectionScrollProvider {

    func setBeginDraggingOffset(_ contentOffsetX: CGFloat) { }

    func setTargetContentOffset(_ targetContentOffset: UnsafeMutablePointer<CGPoint>, for scrollView: UIScrollView) { }

}
