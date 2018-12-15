//
//  Event.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation

/// Event without input and output data.
public protocol EmptyEvent {

    typealias Lambda = () -> Void

    /// Add new listner.
    ///
    /// - Parameter listner: New listner.
    func addListner(_ listner: @escaping Lambda)

    /// Notify all listners.
    func invoke()

    /// Remove all listners.
    func clear()
}

/// Event with input, but without output data.
public protocol Event {

    associatedtype Input
    typealias Lambda = (Input) -> Void

    /// Add new listner.
    ///
    /// - Parameter listner: New listner.
    func addListner(_ listner: @escaping Lambda)

    /// Notify all listners.
    ///
    /// - Parameter input: Data for listners.
    func invoke(with input: Input)

    /// Remove all listners.
    func clear()
}

/// Event with input and output values, but it can have only one listner.
public protocol ValueEvent {

    associatedtype Input
    associatedtype Return

    typealias Lambda = (Input) -> (Return)

    var valueListner: Lambda? { get set }
}

public class BaseEvent<Input>: Event {

    // MARK: - Other

    public typealias Lambda = (Input) -> Void

    public static func += (left: BaseEvent<Input>, right: Lambda?) {
        guard let right = right else {
            return
        }
        left.addListner(right)
    }

    private var listners: [Lambda]

    public init() {
        self.listners = []
    }

    public func addListner(_ listner: @escaping Lambda) {
        self.listners.append(listner)
    }

    public func invoke(with input: Input) {
        self.listners.forEach({ $0(input) })
    }

    public func clear() {
        self.listners.removeAll()
    }
}

public class BaseValueEvent<Input, Return>: ValueEvent {

    public typealias Lambda = (Input) -> (Return)

    public var valueListner: Lambda?
}

public class BaseEmptyEvent: EmptyEvent {

    public typealias Lambda = () -> Void

    public static func += (left: BaseEmptyEvent, right: Lambda?) {
        guard let right = right else {
            return
        }
        left.addListner(right)
    }

    private var listners: [Lambda]

    public init() {
        self.listners = [Lambda]()
    }

    public func addListner(_ listner: @escaping Lambda) {
        self.listners.append(listner)
    }

    public func invoke() {
        self.listners.forEach({ $0() })
    }

    public func clear() {
        self.listners.removeAll()
    }
}
