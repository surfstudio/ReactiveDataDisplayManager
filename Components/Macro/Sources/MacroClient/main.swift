import Macro

// MARK: - Precondition

@Mutable
struct SomeStruct {
    let id: Int = Int.random(in: Int.min...Int.max)
    var someFlag: Bool = false
    var someString: String = ""
}

// MARK: - Helpers

extension SomeStruct {

    func debugPrintAll() {
        debugPrint(someFlag)
        debugPrint(someString)
    }

}

// MARK: - Debugging

var someStruct = SomeStruct()

someStruct.debugPrintAll()

someStruct.set(someFlag: true)
someStruct.set(someString: "echo")

someStruct.debugPrintAll()

someStruct.set(someFlag: false)
someStruct.set(someString: "horray")

someStruct.debugPrintAll()
