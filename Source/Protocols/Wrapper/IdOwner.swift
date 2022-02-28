//
//  IdOwner.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 25.02.2022.
//

import Foundation

/// Protoco wrapperl for object contains `id` property
public protocol IdOwner {
    var id: AnyHashable { get }
}
