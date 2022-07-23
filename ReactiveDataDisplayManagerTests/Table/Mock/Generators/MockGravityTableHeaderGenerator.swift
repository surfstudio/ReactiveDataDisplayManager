//
//  MockGravityTableHeaderGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 20.06.2022.
//

import UIKit
@testable import ReactiveDataDisplayManager

final class MockGravityTableHeaderGenerator: GravityTableHeaderGenerator {

    override var heaviness: Int {
        set { _heaviness = newValue }
        get { return _heaviness }
    }

    private var _heaviness: Int

    init(heaviness: Int = .zero) {
        _heaviness = heaviness
    }

    override func getHeaviness() -> Int {
        heaviness
    }

    override func generate() -> UIView {
        return UIView()
    }

    override func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        return 1
    }

}
