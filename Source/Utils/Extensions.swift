//
//  Extensions.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

extension NSObject {
    // swiftlint:disable force_unwrapping
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    // swiftlint:enable force_unwrapping
}

extension UIViewController {
    class func controller(bundle: Bundle? = nil) -> Self {
        let classReference = self.self
        return classReference.init(nibName: self.nameOfClass,
                                   bundle: bundle == nil ? Bundle(for: self) : bundle)
    }
}

extension UITableView {
    func registerNib(_ cellType: UITableViewCell.Type,
                     bundle: Bundle? = nil) {
        self.register(UINib(nibName: cellType.nameOfClass,
                            bundle: bundle == nil ? Bundle(for: cellType.self) : bundle),
                      forCellReuseIdentifier: cellType.nameOfClass)
    }

    func registerNib(_ cellType: String,
                     bundle: Bundle? = nil) {
        self.register(UINib(nibName: cellType,
                            bundle: bundle == nil ? Bundle(path: cellType) : bundle),
                      forCellReuseIdentifier: cellType)
    }
}

extension UICollectionView {
    func registerNib(_ cellType: UICollectionViewCell.Type,
                     bundle: Bundle? = nil) {
        self.register(UINib(nibName: cellType.nameOfClass,
                            bundle: bundle == nil ? Bundle(for: cellType.self) : bundle),
                      forCellWithReuseIdentifier: cellType.nameOfClass)
    }

    func registerNib(_ cellType: String,
                     bundle: Bundle? = nil) {
        self.register(UINib(nibName: cellType,
                            bundle: bundle == nil ? Bundle(path: cellType) : bundle),
                      forCellWithReuseIdentifier: cellType)
    }

    func registerNib(_ viewType: UICollectionReusableView.Type,
                     kind: String,
                     bundle: Bundle? = nil) {
        self.register(UINib(nibName: viewType.nameOfClass,
                            bundle: bundle == nil ? Bundle(for: viewType.self) : bundle),
                      forSupplementaryViewOfKind: kind,
                      withReuseIdentifier: viewType.nameOfClass)
    }
}

extension UIView {
    /// Loads view from its .xib file
    /// If you use SPM fill bundle property
    static func fromXib(bundle: Bundle? = nil) -> Self? {
        guard let bundle = bundle else {
            let view = Bundle(for: self).loadNibNamed(nameOfClass, owner: nil, options: nil)?.last
            return view as? Self
        }
        return bundle.loadNibNamed(nameOfClass, owner: nil, options: nil)?.last as? Self
    }
}

extension Array {

    /// Index outside array
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

}

@available(iOS 10.0, tvOS 10.0, *)
extension UIImage {

    /// This method creates an image of a view
    public convenience init?(view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }

}
