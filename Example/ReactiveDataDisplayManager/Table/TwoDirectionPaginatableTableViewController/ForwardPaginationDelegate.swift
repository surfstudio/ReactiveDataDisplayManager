//
//  ForwardPaginationDelegate.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Антон Голубейков on 21.06.2023.
//

import ReactiveDataDisplayManager

final class ForwardPaginationDelegate {

    // MARK: - Private properties

    private weak var input: PaginationDelegatable?
    private var loadNextPageAction: (() -> Void)?

    // MARK: - Initialization

    init(input: PaginationDelegatable, nextPageAction: (() -> Void)?) {
        self.input = input
        self.loadNextPageAction = nextPageAction
    }

}

extension ForwardPaginationDelegate: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        self.input?.initializePaginationInput(input: input)
    }

    func loadNextPage(with input: PaginatableInput) {
        loadNextPageAction?()
    }

}
