//
//  Extensions.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

public extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

public extension UIViewController {
    class func controller() -> Self {
        let classReference = self.self
        return classReference.init(nibName: self.nameOfClass, bundle: Bundle(for: self))
    }
}

public extension UITableView {
    func registerNib(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: Bundle(for: cellType.self)), forCellReuseIdentifier: cellType.nameOfClass)
    }
}

public extension UICollectionView {
    func registerNib(_ cellType: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: Bundle(for: cellType.self)), forCellWithReuseIdentifier: cellType.nameOfClass)
    }

    func registerNib(_ viewType: UICollectionReusableView.Type, kind: String) {
        self.register(UINib(nibName: viewType.nameOfClass, bundle: Bundle(for: viewType.self)), forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.nameOfClass)
    }
}

extension Array {

    /// Index outside array
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

}
