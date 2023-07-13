//
//  DataDetection.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 13.07.2023.
//

import Foundation
import UIKit

public struct DataDetection: Equatable {

    // MARK: - Nested types

    public typealias DataDetectionHandler = (String) -> Void

    // MARK: - Properties

    public let linkTextAttributes: [NSAttributedString.Key: Any]
    public var dataDetectionHandler: DataDetectionHandler?
    public var dataDetectorTypes: UIDataDetectorTypes = []

    public init(linkTextAttributes: [NSAttributedString.Key: Any], dataDetectionHandler: @escaping DataDetectionHandler, dataDetectorTypes: UIDataDetectorTypes) {
        self.linkTextAttributes = linkTextAttributes
        self.dataDetectionHandler = dataDetectionHandler
        self.dataDetectorTypes = dataDetectorTypes
    }

    // MARK: - Equatable

    public static func == (lhs: DataDetection, rhs: DataDetection) -> Bool {
        areDictionariesEqual(lhs.linkTextAttributes, rhs.linkTextAttributes) &&
        lhs.dataDetectorTypes == rhs.dataDetectorTypes
    }

}

// MARK: - Private extension

private extension DataDetection {

    private static func areDictionariesEqual(_ lhs: [NSAttributedString.Key: Any]?, _ rhs: [NSAttributedString.Key: Any]?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return lhs == nil && rhs == nil
        }

        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }

}
