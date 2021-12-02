//
//  TableGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class TableGeneratorsProvider: GeneratorsProvider {
    open var generators = [[TableCellGenerator]]()
    open var headers = [TableHeaderGenerator]()
    open var footers = [TableFooterGenerator]()
}
