//
//  Event.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

/// Event with input, but without output data.
public protocol UniversalEvent {

    associatedtype Input
    associatedtype Result
    typealias Lambda = (Input) -> (Result)

    /// Add new listner.
    ///
    /// - Parameter id: a unique id for listner
    /// - Parameter listner: New listner.
    func addListner(with id: String, _ listner: @escaping Lambda)

    /// Notify all listners.
    ///
    /// - Parameter input: Data for listners.
    func invoke(with input: Input) -> [Result]

    /// Remove all listners.
    func clear()
}

// MARK: - Universal Base Event

open class UniversalBaseEvent<Input, Result>: UniversalEvent {

    public typealias Lambda = (Input) -> Result

    public static func += (left: UniversalBaseEvent<Input, Result>, right: Lambda?) {
        guard let right = right else {
            return
        }
        left.addListner(right)
    }

    var listners: [String: Lambda]

    public var isEmpty: Bool {
        return listners.isEmpty
    }

    public var count: Int {
        return listners.count
    }

    public init() {
        self.listners = [:]
    }

    public func addListner(with id: String = UUID().uuidString, _ listner: @escaping Lambda) {
        self.listners[id] = listner
    }

    @discardableResult
    public func invoke(with input: Input) -> [Result] {
        self.listners.values.map { $0(input) }
    }

    public func clear() {
        self.listners.removeAll()
    }

}

// MARK: - Subclasses

public class BaseEvent<Input>: UniversalBaseEvent<Input, Void> { }

public class BaseEmptyEvent: UniversalBaseEvent<Void, Void> {

    public func invoke() {
        super.invoke(with: ())
    }

}
