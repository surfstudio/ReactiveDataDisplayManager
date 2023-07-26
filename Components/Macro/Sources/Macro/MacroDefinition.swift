// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro which generate `mutating func` for all variables inside struct.
@attached(member, names: named(set))
public macro Mutable() = #externalMacro(module: "Macros", type: "MutableMacro")

@attached(conformance)
@attached(member, names: named(create), named(Property))
public macro Buildable() = #externalMacro(module: "Macros", type: "BuildableMacro")
