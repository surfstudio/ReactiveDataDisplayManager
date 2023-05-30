//
//  HashCombiner.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import Foundation

protocol HashCombiner {

    func combine(first: AnyHashable, with second: AnyHashable) -> AnyHashable

}
