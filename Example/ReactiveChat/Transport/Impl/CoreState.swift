//
//  CoreState.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import Foundation
import Combine

final class CoreState {

    // MARK: - Shared state

    static let shared: CoreState = .init()

    // MARK: - Clients

    @Api
    private var apiClient: ApiClient

    @Socket
    private var socketClient: SocketClient

    // MARK: - Properties

    private var currentUser: User?
    private var allMessages: [Message] = []
    private var delegates: [String: AnyObject] = [:]
    private var cancellables: [AnyCancellable] = []

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

        apiClient.get("greet",
                      responseType: Feedback.self)
        .sink(receiveCompletion: { _ in },
              receiveValue: { [weak self] response in
            debugPrint("ReCh response: - \(response)")
            guard let self else {
                return
            }
            self.socketClient.setDelegate(self)
        })
        .store(in: &cancellables)
    }

}

// MARK: - Sender

extension CoreState: Sender {

    func send(text: String) {
        guard let currentUser else {
            return
        }

        let rawMessage = RawMessage(author: currentUser, body: text)

        apiClient.post("send",
                       requestBody: rawMessage,
                       responseType: Feedback.self)
        .sink(receiveCompletion: { _ in },
              receiveValue: { response in
            debugPrint("ReCh response: - \(response.description)")
        })
        .store(in: &cancellables)

    }

}

// MARK: - ChatDelegate

extension CoreState: SocketEventsDelegate {

    func onReceive(message: Message) {
        allMessages.append(message)
        allMessages.sort(by: { $0.timestamp > $1.timestamp })
        notifyChatDelegates { [weak self] delegate in
            guard let messages = self?.allMessages else {
                return
            }
            delegate.onUpdated(messages: messages)
        }
    }

}

// MARK: - Private

private extension CoreState {

    func notifyAuthDelegates(with event: @escaping (AuthDelegate) -> Void) {
        delegates.values.compactMap { $0 as? AuthDelegate }.forEach(event)
    }

    func notifyChatDelegates(with event: @escaping (ChatDelegate) -> Void) {
        delegates.values.compactMap { $0 as? ChatDelegate }.forEach(event)
    }

}
