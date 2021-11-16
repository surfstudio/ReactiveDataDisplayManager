//
//  DragAndDroppableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit

/// Protocol to wrap `DragAndDroppableItem`
@available(iOS 11.0, *)
public protocol DragAndDroppableItemSource {
    var dropableItem: DragAndDroppableItem { get }

    // TODO: - Add support for multiple items
    //    /// Associated generators to drag and drop multiple items
    //    var associatedGenerators: [DragAndDroppableItem] { get set }
}

/// Wrapping identifier for the dragged cell
@available(iOS 11.0, *)
public class DragAndDroppableItem {

    // MARK: - Typealias

    /// Uses an object that conforms to this protocol to initialize an item provider for a copied or dragged item.
    ///
    /// Conforming types: `AVURLAsset`, `CNContact`, `MKMapItem`, `NSAttributedString`, `NSString`, `NSURL`, `NSUserActivity`, `UIColor`, `UIImage`
    public typealias Identifier = NSItemProviderWriting

    // MARK: - Properties

    /// Unique identifier
    open var identifier: Identifier

    // MARK: - Initialization

    public init(identifier: Identifier) {
        self.identifier = identifier
    }

}
#endif
