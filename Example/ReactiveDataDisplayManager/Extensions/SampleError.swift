//
//  SampleError.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 27.03.2023.
//

import Foundation

enum SampleError: Error {

    case sample

    var localizedDescription: String {
        switch self {
        case .sample:
            return "Something went wrong. Please, try again later"
        }
    }

}
