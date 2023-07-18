//
//  FrameProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 18.07.2023.
//

import Foundation

protocol FrameProvider {

    static func getFrame(constraintRect: CGSize, model: some TextProvider) -> CGRect

}

extension FrameProvider {

    static func getFrame(constraintRect: CGSize, model: some TextProvider) -> CGRect {
        switch model.text {
        case .string(let text):
            return text.boundingRect(with: constraintRect,
                                     options: .usesLineFragmentOrigin,
                                     attributes: model.getAttributes(),
                                     context: nil)
        case .attributedString(let attributedText):
            return attributedText.boundingRect(with: constraintRect,
                                               options: .usesLineFragmentOrigin,
                                               context: nil)
        }
    }

}
