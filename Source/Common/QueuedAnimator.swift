//
//  QueuedAnimator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import Foundation
import UIKit

/// Generic animator which collecting empty operations and executing them after `debounceTime` to improve performance
/// - Note: debouncing is applying only for empty operations, because insertions, removal, addition and reload should be executed without delays.
public final class QueuedAnimator<Collection: UIView>: Animator<Collection> {

    private let debouncer: Debouncer
    private let baseAnimator: Animator<Collection>

    public init(baseAnimator: Animator<Collection>, debounceTime: DispatchTimeInterval) {
        self.baseAnimator = baseAnimator
        self.debouncer = .init(queue: .global(qos: .userInitiated), delay: debounceTime)
    }

    override func perform(in collection: Collection, animated: Bool, operation: Animator<Collection>.Operation?) {
        if operation == nil {
            // debounce
            debouncer.run { [weak baseAnimator, weak collection] in
                guard let animator = baseAnimator, let collection = collection else {
                    return
                }
                // waiting for main thread available
                DispatchQueue.main.async {
                    animator.perform(in: collection, animated: animated, operation: operation)
                }
            }
        } else {
            baseAnimator.perform(in: collection, animated: animated, operation: operation)
        }
    }
}
