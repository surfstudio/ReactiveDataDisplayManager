//
//  GeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation

public protocol GeneratorsProvider: AnyObject {
    associatedtype CellGeneratorType
    associatedtype HeaderGeneratorType
    associatedtype FooterGeneratorType

    var generators: [[CellGeneratorType]] { get set }
    var sections: [HeaderGeneratorType] { get set }
    var footers: [FooterGeneratorType] { get set }
}
