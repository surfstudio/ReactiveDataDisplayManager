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
    public func registerCell(_ cellType: UITableViewCell.Type, cellRegisterPolicy: CellRegisterPolicy) {
        if cellRegisterPolicy == .classBased {
            registerClass(cellType)
        } else {
            registerNib(cellType)
        }
    }
    public func registerNib(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: nil), forCellReuseIdentifier: cellType.nameOfClass)
    }
    public func registerClass(_ cellType: UITableViewCell.Type) {
        self.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}

public extension UICollectionView {
    public func registerCell(_ cellType: UICollectionViewCell.Type, cellRegisterPolicy: CellRegisterPolicy) {
        if cellRegisterPolicy == .classBased {
            registerClass(cellType)
        } else {
            registerNib(cellType)
        }
    }
    public func registerNib(_ cellType: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: nil), forCellWithReuseIdentifier: cellType.nameOfClass)
    }
    public func registerClass(_ cellType: UICollectionViewCell.Type) {
        self.register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
