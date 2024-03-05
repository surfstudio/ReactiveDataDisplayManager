//
//  Protocols+EditorWrapper.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import Foundation

@propertyWrapper
struct Service<T> {

    var wrappedValue: T? {
        CoreState.shared as? T
    }

    init(serviceType: T.Type) { }

}

@propertyWrapper
struct Api {

    private static var instances: [String: ApiClient] = [:]

    private let server: String

    var wrappedValue: ApiClient {
        if let storedInstance = Self.instances[server] {
            return storedInstance
        } else {
            let newInstance = URLSessionApiClient(server: server)
            Self.instances.updateValue(newInstance, forKey: server)
            return newInstance
        }
    }

    init(server: String = Server.api.rawValue) {
        self.server = server
    }

}

@propertyWrapper
struct Socket {

    private static var instances: [String: SocketClient] = [:]

    private let server: String

    var wrappedValue: SocketClient {
        if let storedInstance = Self.instances[server] {
            return storedInstance
        } else {
            let newInstance = URLSessionWebSocketClient(server: server)
            Self.instances.updateValue(newInstance, forKey: server)
            return newInstance
        }
    }

    init(server: String = Server.webSockets.rawValue) {
        self.server = server
    }

}
