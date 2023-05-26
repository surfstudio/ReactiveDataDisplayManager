//
//  StringAttributableStyle.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import SurfUtils

public protocol StringAttributableStyle {
    func attributes() -> [StringAttribute]
}
