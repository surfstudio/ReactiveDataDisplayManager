//
//  TapHandler.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 13.07.2023.
//

import Foundation
import UIKit

public struct TapHandler: Equatable {

    // MARK: - Properties

    public let id = UUID()
    public let tapAction: (() -> Void)?

    // MARK: - Public init

    public init(tapAction: (() -> Void)?) {
        self.tapAction = tapAction
    }

    // MARK: - Equatable

    public static func == (lhs: TapHandler, rhs: TapHandler) -> Bool {
        return lhs.id == rhs.id
    }

}
