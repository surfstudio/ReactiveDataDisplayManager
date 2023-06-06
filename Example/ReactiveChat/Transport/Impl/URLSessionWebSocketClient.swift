//
//  URLSessionWebSocketClient.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation
import Combine

final class URLSessionWebSocketClient: SocketClient {

    private let server: URL

    private var task: URLSessionWebSocketTask?

    private weak var delegate: SocketEventsDelegate?

    init(server: String) {
        guard let server = URL(string: [server, "connect"].joined(separator: "/")) else {
            fatalError("Server for websockets has bad format.")
        }
        self.server = server
    }

    // MARK: - SocketClient

    func setDelegate(_ delegate: SocketEventsDelegate) {
        self.delegate = delegate
    }

    func connect() {

        let session = URLSession(configuration: .default)
        task = session.webSocketTask(with: server)

        doRead()
        task?.resume()
    }

    func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
    }

}

// MARK: - Private

private extension URLSessionWebSocketClient {

    func doRead() {
        task?.receive { [weak self] (result) in
            switch result {
            case .success(let message):
                self?.onSocketReceived(message: message)
                break
            case .failure(let error):
                self?.onSocketFailed(with: error)
                return
            }
            self?.doRead()
        }
    }

    func onSocketReceived(message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let string):
            onSocketReceived(string: string)
        case .data(let data):
            onSocketReceived(data: data)
        @unknown default:
            break
        }
    }

    func onSocketReceived(data: Data) {
        debugPrint("ReCh socket received data: \(data.count)")
        guard let event = SocketEvent.from(json: data) else {
            return
        }
        switch event {
        case .newMessageReceived(let message):
            delegate?.onReceive(message: message)
        }
    }

    func onSocketReceived(string: String) {
        debugPrint("ReCh socket received string: \(string)")
    }

    func onSocketFailed(with error: Error) {
        debugPrint("ReCh socket received error: \(error)")
    }

}
