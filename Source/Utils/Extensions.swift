//
//  Extensions.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    class func controller() -> Self {
        let classReference = self.self
        return classReference.init(nibName: self.nameOfClass, bundle: Bundle(for: self))
    }
}

extension UITableView {
    func registerNib(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: Bundle(for: cellType.self)), forCellReuseIdentifier: cellType.nameOfClass)
    }

    func registerNib(_ cellType: String) {
        self.register(UINib(nibName: cellType, bundle: Bundle(path: cellType) ), forCellReuseIdentifier: cellType)
    }
}

extension UICollectionView {
    func registerNib(_ cellType: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cellType.nameOfClass, bundle: Bundle(for: cellType.self)), forCellWithReuseIdentifier: cellType.nameOfClass)
    }

    func registerNib(_ cellType: String) {
        self.register(UINib(nibName: cellType, bundle: Bundle(path: cellType)), forCellWithReuseIdentifier: cellType)
    }

    func registerNib(_ viewType: UICollectionReusableView.Type, kind: String) {
        self.register(UINib(nibName: viewType.nameOfClass, bundle: Bundle(for: viewType.self)), forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.nameOfClass)
    }
}

extension UIView {
    /// Loads view from its .xib file
    static func fromXib() -> Self? {
        let view = Bundle(for: self).loadNibNamed(nameOfClass, owner: nil, options: nil)?.last
        return view as? Self
    }
}

extension Array {

    /// Index outside array
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

}
