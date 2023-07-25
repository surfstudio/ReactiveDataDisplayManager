//
//  ContentOffsetStateKeeper.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 20.07.2023.
//

import UIKit

protocol ContentOffsetStateKeeper {

    var scrollView: UIScrollView? { get set }
    var progressView: UIView? { get set }

    // Сохраняет contentSize.height
    func saveCurrentState()

    // Вычисляет finalOffset и устанавливает его используя setContentOffset
    func resetOffset(canIterate: Bool)

}

extension ContentOffsetStateKeeper {

    func saveCurrentState() { }
    func resetOffset(canIterate: Bool) { }

}
