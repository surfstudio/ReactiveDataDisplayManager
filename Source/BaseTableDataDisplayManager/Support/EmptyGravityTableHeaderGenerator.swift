//
//  EmptyGravityTableHeaderGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 17.10.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

public class EmptyGravityTableHeaderGenerator: GravityTableHeaderGenerator {
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
