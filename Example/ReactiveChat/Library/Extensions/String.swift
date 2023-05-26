//
//  String.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import Foundation

extension String {

    /// Drop empty prefix.
    /// - Example: Input **"     Hello"** -> Output **"Hello"**
    func trimWhitespacePrefix() -> String {
        let whitespaces = prefix(while: { $0 == " " })
        return String(self.dropFirst(whitespaces.count))
    }

    /// Calculate **height** of string required to display `self` in bounds of concrete **width**
    func height(withConstrainedWidth width: CGFloat,
                attrs: [NSAttributedString.Key: Any]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: attrs,
                                            context: nil)

        return ceil(boundingBox.height)
    }

    /// Checking that `self` + `text` characters count is **less or equal** than `characterLimit`
    func canApplyReplacement(with range: NSRange, text: String, characterLimit: Int) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: self) else { return false }
        let substringToReplace = self[rangeOfTextToReplace]
        let count = self.count - substringToReplace.count + text.count
        return count <= characterLimit
    }

}
