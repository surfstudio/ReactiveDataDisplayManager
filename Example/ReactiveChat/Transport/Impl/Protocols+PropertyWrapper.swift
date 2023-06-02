//
//  Protocols+PropertyWrapper.swift
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

    init(server: String) {
        self.server = server
    }

}
