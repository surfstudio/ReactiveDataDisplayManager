//
//  ConstructionType.swift
//  Pods
//
//  Created by Никита Коробейников on 15.12.2021.
//

import UIKit

/// Enum with different types of constructing cells for `nonReusable` generator
/// - xib - init from paired `.xib` file
/// - manual - init from code
public enum ConstructionType {
    case xib
    case manual
}
