//
//  Modifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

open class Modifier<View: UIView, Animation> {

    public private(set) weak var view: View?

    public init(view: View) {
        self.view = view
    }

    open func reload() {
        // Stub
    }

    open func replace(at indexPath: IndexPath, with removeAnimation: Animation, and insertAnimation: Animation) {
        // Stub
    }

    open func insertSections(at indexPaths: IndexSet, with insertAnimation: Animation) {
        // Stub
    }

    open func insertRows(at indexPaths: [IndexPath], with insertAnimation: Animation) {
        // Stub
    }
}
