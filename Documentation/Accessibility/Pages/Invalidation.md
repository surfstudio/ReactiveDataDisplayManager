[⏎ Overview](../Overview.md)

# Invalidation

**RDDM**'s accessibility plugin allows you to use your dynamic properties in accessibility strategies and so on. But if some properties will changed while the cell is on screen, you need to invalidate current accessibility parameters. For these needs you need implement `AccessibilityInvalidatable` protocol.

```swift
protocol AccessibilityInvalidatable: AccessibilityItem { 
    var accessibilityInvalidator: AccessibilityItemInvalidator? { get set }
}
```

This protocol required you to define an invalidatior property. Through this invalidator you can call `invalidateParameters()` method which triggers re-set of all accessibility parameters.

*Important: this property is fully managed by accessibility plugin, so you don't need to set it. But if you want to add your own funtionality, see [Advanced Usage](./Advanced%20Usage.md). Invalidator may be `nil` if cell isn't on screen, so the latest parameters will be applied on `willDisplay` after the `configure()` method.*

*Example:*

```swift
func updateState(state: String, isSelected: Bool) {
    valueStrategy = .just(state)
    isSelected ? traitsStrategy.insert(.selected) : traitsStrategy.remove(.selected)
    accessibilityInvalidator?.invalidateParameters()
}
```

<br>

If you manage cell states like `isSelected`, `isEnabled`, you may use corresponding accessibility traits. But in a default `AccessibilityItem` these states wouldn't be changes because of `shouldOverrideStateTraits` property which by default is `false`. So you need to define this property as `true`.

*Example:*

```swift
var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
var valueStrategy: AccessibilityStringStrategy = .just(nil)
lazy var traitsStrategy: AccessibilityTraitsStrategy = .from(object: titleLabel)
var shouldOverrideStateTraits: Bool { true }

var accessibilityInvalidator: AccessibilityItemInvalidator?
```

<br>

Next [Debugging →](./Debugging.md)