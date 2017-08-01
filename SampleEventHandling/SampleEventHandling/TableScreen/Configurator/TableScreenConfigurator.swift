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
        presenter.model = User(name: "Тест_имя", surname: "Тест_фамилия", old: 21, birthDate: Date(), email: "sample_email@test.com")
        vc.presenter = presenter
        vc.displayManager = ddm
        return vc
    }
}
