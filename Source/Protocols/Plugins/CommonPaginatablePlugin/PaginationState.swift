//
//  PaginationState.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 20.07.2023.
//

import Foundation

public enum PaginationState {
    case idle
    case loading
    case error(Error?)
}
