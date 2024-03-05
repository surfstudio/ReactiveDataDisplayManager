//
//  MacroError.swift
//
//
//  Created by Никита Коробейников on 16.06.2023.
//

public enum MacroError: Error {

    case onlyApplicableToStruct
    case typeAnnotationRequiredFor(variableName: String)
    case failedToExtractTypeOfBaseStruct

}
