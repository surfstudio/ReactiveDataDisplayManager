//
//  UIResponder.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit

extension UIResponder {

    /// Removing Undo, Redo, Copy & Paste options
    func removeUndoRedoOptions() {
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
    }
}
