//
//  RegisterableItem.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

public protocol RegisterableItem {
    var descriptor: String { get }
}

public extension RegisterableItem {

    var descriptor: String {
        String(describing: Self.self)
    }

}
