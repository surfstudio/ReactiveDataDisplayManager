//
//  RefreshableMocks.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

@testable import ReactiveDataDisplayManager

#if os(iOS)
final class RefreshableInputMock: RefreshableInput {

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

final class RefreshableOutputMock: RefreshableOutput {

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
