//
//  MockGravityTableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 20.06.2022.
//

@testable import ReactiveDataDisplayManager

class MockGravityTableCellGenerator: StubTableCellGenerator, GravityItem {

    var heaviness: Int

    init(heaviness: Int = .zero) {
        self.heaviness = heaviness
    }

    func getHeaviness() -> Int {
        heaviness
    }

}
