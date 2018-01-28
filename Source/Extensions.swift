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
    public class func controller() -> Self {
        let classReference = self.self
        return classReference.init(nibName: self.nameOfClass, bundle: nil)
    }
}

public extension UITableView {
    public func registerNib(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: nil), forCellReuseIdentifier: cellType.nameOfClass)
    }
}

public extension UICollectionView {
    public func registerNib(_ cellType: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: nil), forCellWithReuseIdentifier: cellType.nameOfClass)
    }
}

