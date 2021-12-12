//
//  GeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation

public protocol GeneratorsProvider: AnyObject {
    associatedtype GeneratorType
    associatedtype HeaderGeneratorType
    associatedtype FooterGeneratorType

    var sections: [SectionType<GeneratorType, HeaderGeneratorType, FooterGeneratorType>] { get set }
}

public extension GeneratorsProvider {

    func getOldSections() -> OldSection<GeneratorType, HeaderGeneratorType, FooterGeneratorType> {
        var generators = [[GeneratorType]]()
        var headers = [HeaderGeneratorType]()
        var footers = [FooterGeneratorType]()
        for section in sections {
            headers.append(section.header)
            footers.append(section.footer)
            generators.append(section.generators)
        }
        return .init(generators: generators,
                     headers: headers,
                     footers: footers)
    }

}
