//
//  BackwardPaginationDelegate.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Антон Голубейков on 21.06.2023.
//

import ReactiveDataDisplayManager

final class BackwardPaginationDelegate {

    // MARK: - Private properties

    private weak var input: PaginationDelegatable?
    private var loadPrevPageAction: (() -> Void)?

    // MARK: - Initialization

    init(input: PaginationDelegatable, prevPageAction: (() -> Void)?) {
        self.input = input
        self.loadPrevPageAction = prevPageAction
    }

}

extension BackwardPaginationDelegate: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        self.input?.initializeBackwardPaginationInput(input: input)
    }

    func loadNextPage(with input: PaginatableInput) { }

    func loadPrevPage(with input: PaginatableInput) {
        loadPrevPageAction?()
    }

}
