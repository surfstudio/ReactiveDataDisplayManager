//
//  TableGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
import Combine

open class TableGeneratorsProvider: GeneratorsProvider {

    open var sections = [TableHeaderGenerator]()
    open var generators = [[TableCellGenerator]]()
    open var footers = [TableFooterGenerator]()
}
