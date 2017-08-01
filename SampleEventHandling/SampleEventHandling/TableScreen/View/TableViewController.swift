//
//  ViewController.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, ViewInput {

    // MARK: - IBOutlets

    @IBOutlet fileprivate weak var tableView: UITableView!

    // MARK: - Properties

    public var displayManager: BaseTableDataDisplayManager!
    public var presenter: PresenterOutput!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.configure()
    }

    func configure(with model: User) {

        self.displayManager.setTableView(self.tableView)

        let nameGenerator = TextWithLabelGenerator(model: model.name, text: "Имя")
        nameGenerator.textShouldChange.valueListner = self.presenter.nameChange
        self.displayManager.addCellGenerator(nameGenerator)

        let surnameGenerator = TextWithLabelGenerator(model: model.surname, text: "Фамилия")
        surnameGenerator.textShouldChange.valueListner = self.presenter.surnameChange
        self.displayManager.addCellGenerator(surnameGenerator)

        let emailGenerator = TextWithLabelGenerator(model: model.email, text: "Email")
        emailGenerator.textShouldChange.valueListner = self.presenter.emailChange(email:)
        self.displayManager.addCellGenerator(emailGenerator)
    }
}
