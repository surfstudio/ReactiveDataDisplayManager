//
//  PaginationDelegatable.swift
//  ReactiveDataDisplayManagerExampleUITests
//
//  Created by Антон Голубейков on 21.06.2023.
//

import ReactiveDataDisplayManager

protocol PaginationDelegatable: AnyObject {

    func initializePaginationInput(input: PaginatableInput)

}
