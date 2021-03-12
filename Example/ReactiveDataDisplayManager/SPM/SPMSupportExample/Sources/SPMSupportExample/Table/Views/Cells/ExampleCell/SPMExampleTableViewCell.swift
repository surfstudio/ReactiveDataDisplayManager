//
//  SPMExampleTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Владислав Янковенко on 10.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

public class SPMExampleTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension SPMExampleTableViewCell: ConfigurableItem {

    public static func bundle() -> Bundle? {
        Bundle.module
    }

    public func configure(with model: String) {
        titleLabel.text = model
    }

}
