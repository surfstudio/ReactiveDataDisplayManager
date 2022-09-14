//
//  BasicOperations+Commands.swift
//  Pods
//
//  Created by Никита Коробейников on 26.04.2022.
//

// MARK: - Executable Command

infix operator =>: AdditionPrecedence

/// Executable command on any `DataDisplayManager`
public enum DataDisplayCommand {
    /// Equiavalent of `forceRefill`
    case reload
    /// Equiavalent of `forceRefill` with completion closure
    case reloadWithCompletion(() -> Void)
}

public extension DataDisplayManager {

    static func => (left: Self, right: DataDisplayCommand) {
        switch right {
        case .reload:
            left.forceRefill()
        case .reloadWithCompletion(let completion):
            left.forceRefill(completion: completion)
        }
    }

}

// MARK: - Substraction Command

/// SubstractionCommand on any `DataDisplayManager`
public enum SubstractionCommand {
    /// Equiavalent of `clearCellGenerators`
    case all
}

public extension DataDisplayManager {

    static func -= (left: Self, right: SubstractionCommand) {
        switch right {
        case .all:
            left.clearCellGenerators()
        }
    }

}
