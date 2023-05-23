//
//  CommonHashCombiner.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import Foundation

final class CommonHashCombiner: HashCombiner {

    func combine(first: AnyHashable, with second: AnyHashable) -> AnyHashable {
        var hasher = Hasher()
        hasher.combine(first)
        hasher.combine(second)
        return hasher.finalize()
    }

}
