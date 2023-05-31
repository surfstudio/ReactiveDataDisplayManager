//
//  UITextView.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit

extension UITextView {

    func scrollToLastLine() {
        let lastLine = NSRange(location: text.count - 1, length: 1)
        scrollRangeToVisible(lastLine)
    }

    func numberOfLines() -> UInt {
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines: UInt = 0
        var index = 0
        var lineRange = NSRange()

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }

        if layoutManager.extraLineFragmentUsedRect != CGRect.zero {
            numberOfLines += 1
        }

        return numberOfLines
    }

}
