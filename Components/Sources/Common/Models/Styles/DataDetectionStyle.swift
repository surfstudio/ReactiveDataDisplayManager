//
//  DataDetectionStyle.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 13.07.2023.
//
#if os(iOS)
import Foundation
import UIKit

public struct DataDetectionStyle: Equatable {

    // MARK: - Nested types

    public typealias Handler = (URL) -> Void

    // MARK: - Properties

    public let id: AnyHashable
    public let linkTextAttributes: [NSAttributedString.Key: Any]
    public var handler: Handler?
    public var dataDetectorTypes: UIDataDetectorTypes = []

    public init(id: AnyHashable, linkTextAttributes: [NSAttributedString.Key: Any], handler: @escaping Handler, dataDetectorTypes: UIDataDetectorTypes) {
        self.id = id
        self.linkTextAttributes = linkTextAttributes
        self.handler = handler
        self.dataDetectorTypes = dataDetectorTypes
    }

    // MARK: - Equatable

    public static func == (lhs: DataDetectionStyle, rhs: DataDetectionStyle) -> Bool {
        lhs.id == rhs.id &&
        areDictionariesEqual(lhs.linkTextAttributes, rhs.linkTextAttributes) &&
        lhs.dataDetectorTypes == rhs.dataDetectorTypes
    }

}

// MARK: - Private extension

private extension DataDetectionStyle {

    private static func areDictionariesEqual(_ lhs: [NSAttributedString.Key: Any]?, _ rhs: [NSAttributedString.Key: Any]?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return lhs == nil && rhs == nil
        }

        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }

}
#endif
