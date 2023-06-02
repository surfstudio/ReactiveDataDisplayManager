//
//  EmptyGravityFooterGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 01.06.2023.
//

import UIKit

public class EmptyGravityFooterGenerator: GravityTableFooterGenerator {
    open override func generate() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    open override func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        return 0.01
    }

    open override func getHeaviness() -> Int {
        return 0
    }
}
