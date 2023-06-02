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
        self.server = URL(string: [server, "connect"].joined(separator: "/"))!
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
                switch message {
                case .string(let string):
                    debugPrint("ReCh socket received string: \(string)")
                case .data(let data):
                    debugPrint("ReCh socket received data: \(data.count)")
                    guard let event = SocketEvent.from(json: data) else {
                        return
                    }
                    switch event {
                    case .newMessageReceived(let message):
                        self?.delegate?.onReceive(message: message)
                    }
                @unknown default:
                    break
                }
                break
            case .failure(let error):
                debugPrint("ReCh socket received error: \(error)")
                return
            }
            self?.doRead()
        }
    }

}
