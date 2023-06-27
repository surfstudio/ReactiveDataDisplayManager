//
//  FatalErrorUtil.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Ivan Smetanin on 25/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import UIKit

enum FatalErrorUtil {

    static var fatalErrorClosure: (String, StaticString, UInt) -> Void = defaultFatalErrorClosure

    private static let defaultFatalErrorClosure: (String, StaticString, UInt) -> Void = { Swift.fatalError($0, file: $1, line: $2) }

    static func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        fatalErrorClosure(message(), file, line)
    }

    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Void) {
        fatalErrorClosure = closure
    }

    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }

}
