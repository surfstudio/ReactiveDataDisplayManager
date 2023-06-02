//
//  CollectionChatViewController.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 25.05.2023.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

final class CollectionChatViewController: UIViewController {

    // MARK: - Services

    @Service(serviceType: StateKeeper.self)
    private var stateKeeper: StateKeeper?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        stateKeeper?.addDelegate(delegate: self, with: String(describing: Self.self))
        view.backgroundColor = .blue
    }

    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            stateKeeper?.removeDelegate(by: String(describing: Self.self))
        }
    }

}

// MARK: - ChatDelegate

extension CollectionChatViewController: ChatDelegate {

    func onUpdated(messages: [Message]) {
        debugPrint("Messages in collection: \(messages)")
    }

}
