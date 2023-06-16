[⏎ Overview](../Overview.md)

# Usage

To make your App more freandly for disabled users **RDDM** provides a set of instruments for accessibility optimizations.

By default, all cells inside tables and collections are not accessibility elements, that can add difficult to users to navigate and read them. Despite this fact, many accessibility consultants recommend to make cells a single accessibility element.

**RDDM** in initial will not make any changes to accessibility elements hierarchy, so you can manage your own optimization. But it enables an accessibility plugin at all builders to be work with `AccessibilityItems`.

<br>

## AccessibilityItem

```swift
protocol AccessibilityItem: UIView, ... {}
```

Main protocol that need to be adopted by cells, headers and footers. It's also inherited from some accessibility parameters providers which will be setted by internal modifier.

*To use **RDDM**'s accessibility optimizations you only need to add this protocol to your cell's classes and fill required parameters.*

*Example:*
```swift
// MARK: - AccessibilityItem

extension TitleCollectionListCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

}
```

After that, a cell, header or footer which is `AccessibilityItem`, becomes an [accessibility element](./UIAccessibility%20Basics.md#isaccessibilityelement).

<img src="https://i.ibb.co/vBN0RLL/2023-06-06-15-49-52.png" alt="before" width=49%> <img src="https://i.ibb.co/4P079Qb/2023-06-06-15-49-28.png" alt="after" width=49%>

***
<br>

## Strategies

To provide accessibility parameters you can use **RDDM**'s strategies `AccessibilityStringStrategy` and `AccessibilityTraitsStrategy`. With these strategies you can easy provide default accessibility parameters such as `accessibilityLabel, accessibilityValue, accessibilityTraits`.

*If you need other parameters, you can define your own item and modifier for it, see [Advanced Usage](./Advanced%20Usage.md). Also you can provide `self` propetries and use [invalidation mechanism](./Invalidation.md) to update them.*

<br>

#### AccessibilityStringStrategy
This strategy is used for string parameters [`accessibilityLabel`](./UIAccessibility%20Basics.md#accessibilitylabel) and [`AccessibilityValue`](./UIAccessibility%20Basics.md#Accessibilityvalue).
Strategy for label is required for item.

```swift
public enum AccessibilityStringStrategy {
    case ignored
    case just(String?)
    case from(object: NSObject, keyPath: KeyPath<NSObject, String?> = \.accessibilityLabel)
    indirect case joined([AccessibilityStringStrategy])
}
```

- `.ignored` - value will not be changed by this strategy.
- `.just(String?)` - simple string value, can be nil.
- `.from(object: NSObject, keyPath: KeyPath<NSObject, String?>)` - a reference value from object with specified keypath from value would be taken. By default it's `accessibilityLabel`.

*Note: `NSObject` is used because all accessibility parameters defined in it. Default parameter is `accessibilityLabel` because labels and buttons have this parameter is equal to their title. If you want to use `text` from label or `title(for:)` from button then provide `.just` case with this value, it also will work.*

- `.joined([AccessibilityStringStrategy])` - a combination of strategies, joined without spaces.

*Example: a cell with `UIButton` and `UISwitch`*
```swift
var labelStrategy: AccessibilityStringStrategy { .from(object: button) }

var valueStrategy: AccessibilityStringStrategy {
    .joined([
        .just(isSmall ? "collapsed" : "expanded"),
        .just(", is animated: "),
        .from(object: switcher, keyPath: \.accessibilityValue)
    ])
}
```

<br>

#### AccessibilityTraitsStrategy

This strategy is used for [`accessibilityTraits`](./UIAccessibility%20Basics.md#accessibilitytraits) parameter. Is required for item.

```swift
public enum AccessibilityTraitsStrategy {
    case ignored
    case just(UIAccessibilityTraits)
    case from(object: NSObject)
    case merge([NSObject])
}
```

- `.ignored` - value will not be changed by this strategy.
- `.just(UIAccessibilityTraits)` - simple accessibility traits.
- `.from(object: NSObject)` - a reference traits from another object
- `.merge([NSObject])` - a reference traits merged from specified objects

*Example: the same cell with `UIButton` and `UISwitch`*
```swift
var traitsStrategy: AccessibilityTraitsStrategy { .from(object: button) }
```

*Note: `UISwitch` has a unique hidden trait, that only reads values 0 or 1 and localize them. If you want to use this trait, you need use `accessibilityValue` only from switcher and do not change it.*

***
<br><br>

## Providers

Providers in **RDDM** is a separate parameters containers which are included in `AccessibilityItem`. But these providers can be used for generators to combine them with cell's parameters.

*Note: only `AccessibilityItem` defined for a cell modifies it and apply provided parameters.*

<br>

#### AccessibilityStrategyProvider

This is common provider for `accessibilityLabel, accessibilityValue` and `accessibilityTraits` strategies.

```swift
public protocol AccessibilityStrategyProvider {
    var labelStrategy: AccessibilityStringStrategy { get }
    var valueStrategy: AccessibilityStringStrategy { get }
    var traitsStrategy: AccessibilityTraitsStrategy { get }
    var isAccessibilityIgnored: Bool { get }
}
```

The last parameter `isAccessibilityIgnored` idicates that `AccessibilityItem` should become an accessibility element. Equals `true` if all strategies is in state `.ignored`. Can be overrided to make cell a container for other accessibility elements.

Some **RDDM** generators already includes this provider to provide nesssecary traits: `.header` for header generators and `.button` for selectable and foldable generators.

*Example:*
```swift
extension SelectableItem: AccessibilityStrategyProvider {
    public var labelStrategy: AccessibilityStringStrategy { .ignored }
    public var traitsStrategy: AccessibilityTraitsStrategy { didSelectEvent.isEmpty ? .ignored : .just(.button) }
}
```

`labelStrategy` and `traitsStrategy` is required parameters and `valueStrategy` is `.ignored` by default.

<br>

#### AccessibilityActionsProvider

A provider for [custom actions](./UIAccessibility%20Basics.md#accessibilitycustomactions). In item is defined as empty array.

```swift
public protocol AccessibilityActionsProvider {
    func accessibilityActions() -> [UIAccessibilityCustomAction]
}
```

*Note: all system actions such as swipes, editing, moving, drag and drop are already provided by UIKit in another way. Use this actions provider to add custom interaction with the cell content.*

*Example:*
```swift
func accessibilityActions() -> [UIAccessibilityCustomAction] {
    let switchAction = UIAccessibilityCustomAction(name: "Toggle animated",
                                                   target: self,
                                                   selector: #selector(accessibilityActivateSwitch))
    return [switchAction]
}
```

<br>

Next [Invalidation →](./Invalidation.md)