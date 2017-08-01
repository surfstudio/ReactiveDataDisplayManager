//
//  Event.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation

protocol Event {

    associatedtype Input
    typealias Lambda = (Input)->(Void)

    /// Добавляет нового слушателя событий
    ///
    /// - Parameter listner: Новый слушатель
    func addListner(_ listner: @escaping Lambda)

    /// Оповещает всех слушателей о проишедшем событии
    ///
    /// - Parameter input: Данные для слушателей.
    func invoke(with input: Input)
}

/// Эвент, реализующий событие, которое может возвращать значение
protocol ValueEvent {

    associatedtype Input
    associatedtype Return

    typealias Lambda = (Input)->(Return)

    var valueListner: Lambda? { get set }
}
/// Базовая имплементация события, котоаря опять же может дополняться до необходимой, если это нужно.
/// Если нужно иное поведение - либо сабкласимся, либо создаем новый класс и имлементим протоколы 💪
class BaseEvent<Input>: Event {

    // MARK: - Other

    typealias Lambda = (Input)->(Void)

    static func += (left: BaseEvent<Input>, right: @escaping Lambda) {
        left.addListner(right)
    }

    private var listners: [Lambda]

    init() {
        self.listners = [Lambda]()
    }

    func addListner(_ listner: @escaping Lambda) {
        self.listners.append(listner)
    }

    func invoke(with input: Input) {
        self.listners.forEach({$0(input)})
    }
}

/// Базовая имплементация события, которое умеет возвращать значение. Эта имплементация опять же может дополняться до необходимой, если это нужно.
/// Если нужно иное поведение - либо сабкласимся, либо создаем новый класс и имлементим протоколы 💪
class BaseValueEvent<Input, Return>: ValueEvent {

    typealias Lambda = (Input)->(Return)

    var valueListner: Lambda?
}
