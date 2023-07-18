//
//  TextProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 18.07.2023.
//

import Foundation

public protocol TextProvider {

    var text: TextValue { get }

    func getAttributes() -> [NSAttributedString.Key: Any]

}
