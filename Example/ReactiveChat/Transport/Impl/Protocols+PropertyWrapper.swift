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
