//
//  Debouncer.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import Foundation

final class Debouncer {

    private let queue: DispatchQueue
    private let delay: DispatchTimeInterval

    private var workItem: DispatchWorkItem?

    init(queue: DispatchQueue, delay: DispatchTimeInterval) {
        self.queue = queue
        self.delay = delay
    }

    func run(action: @escaping () -> Void) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)

        self.workItem = workItem
    }

    func cancel() {
        workItem?.cancel()
        workItem = nil
    }

}
