//
//  TableScreenConfigurator.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation

class TableScreenConfigurator {

    func configure() -> TableViewController {
        let vc = TableViewController.controller()
        let presenter = TablePresenter()
        let ddm = BaseTableDataDisplayManager()
        presenter.view = vc
        vc.presenter = presenter
        vc.displayManager = ddm
        return vc
    }
}
