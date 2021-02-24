//
//  BaseTitleTableGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

//import ReactiveDataDisplayManager
//
//class BaseTitleTableGenerator: SelectableItem {
//
//    // MARK: - Events
//
//    var didSelectEvent = BaseEvent<Void>()
//
//    // MARK: - Properties
//
//    var didSelected: Bool = false
//    var isNeedDeselect: Bool = true
//    
//    // MARK: - Private Properties
//
//    private let model: String
//
//    // MARK: - Initializers
//
//    public init(model: String) {
//        self.model = model
//    }
//
//}
//
//// MARK: - TableCellGenerator
//
//extension BaseTitleTableGenerator: TableCellGenerator {
//
//    var identifier: String {
//        return String(describing: TitleTableViewCell.self) 
//    }
//
//}
//
//// MARK: - ViewBuilder
//
//extension BaseTitleTableGenerator: ViewBuilder {
//
//    func build(view: TitleTableViewCell) {
//        view.configure(with: model)
//    }
//
//}
