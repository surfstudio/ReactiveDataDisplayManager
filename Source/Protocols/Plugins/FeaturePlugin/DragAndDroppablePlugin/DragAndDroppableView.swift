//
//  DragAndDroppableView.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import Foundation
import UIKit

@available(iOS 11.0, *)
public protocol DragAndDroppableView {
    var hasActiveDrag: Bool { get }
}

extension UITableView: DragAndDroppableView { }

extension UICollectionView: DragAndDroppableView { }
#endif
