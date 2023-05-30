//
//  CoreState.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import Foundation

final class CoreState {

    // MARK: - Shared state

    static let shared: CoreState = .init()

    // MARK: - Properties

    private var currentUser: User?
    private var delegates: [String: AnyObject] = [:]

    // MARK: - Private init

    private init() { }

}

// MARK: - StateKeeper

extension CoreState: StateKeeper {

    func addDelegate<T>(delegate: T, with key: String) where T: AnyObject {
        delegates.updateValue(delegate, forKey: key)
    }

    func removeDelegate(by key: String) {
        delegates.removeValue(forKey: key)
    }

}

// MARK: - Authenticator

extension CoreState: Authenticator {

    func auth(by name: String) {
        currentUser = User(name: name)
        notifyAuthDelegates(with: { $0.onAuthanticated() })
    }

}

// MARK: - Sender

extension CoreState: Sender {

    func send(text: String) {
        // TODO: - implement sending of message
        debugPrint("RC message <\(text)> sent")
    }

}

// MARK: - Private

private extension CoreState {

    func notifyAuthDelegates(with event: @escaping (AuthDelegate) -> Void) {
        delegates.values.compactMap { $0 as? AuthDelegate }.forEach(event)
    }

}
