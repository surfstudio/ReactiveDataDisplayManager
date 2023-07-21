[⏎ Overview](../Overview.md)

# Advanced Usage

## How it works

The main logic is located in `TableAccessibilityPlugin` and `CollectionAccessibilityPlugin`. It automatically added to all builders to be ready work with `AccessibilityItems`. It's a common plugin that works with delgate events.

**Only each `AccessibilityItem` will be processed by these plugins.**

On `willDisplay` event every time 2 steps are happens:

1. Element will be passed to its defined modifier through corresponding methods `modify(item: accessibilityItem)` or `modify(item: accessibilityItem, generator: generator)` if generator implements `AccessibilityStrategyProvider`.
2. A new invalidator instance is setted with provided `indexPath` if supports invalidation mechanism. Its invalidate method calls delegate to pass the new event `invalidatedAccessibility` which will execute step 1.

On `didEndDisplay` event the plugin will remove invalidator if it exists.

<img src="https://i.ibb.co/SfbfzZJ/2023-06-16-18-43-17.png" alt="Plugin Example">

<br>

This is the essence how accessibility works in **RDDM**, so you don't have access to its functionality. Instead, you may have full control under modify and invalidate processes.

***

<br>

## Modify custom accessibility parameters

If you need to set a parameter which is not presented or change the way how they setting, you need to define your own strategy provider (or custom accessibility item) and modifier. You can combine your custom logic with base functionality.

*Example:*
```swift
enum CustomAccessibilityModifier: AccessibilityModifier {
    static func modify(item: AccessibilityItem) {
        // set base parameters
        BaseAccessibilityModifier.modify(item)

        // additional logic for custom item
        guard let item = item as? CustomAccessibilityItem else { return }
        item.accessibilityIdentifier = item.identifier.value
        item.accessibilityHint = item.hintStrategy.value
    }

    // corresponding method implementation with generator
}

protocol CustomAccessibilityItem: AccessibilityItem { 
    var modifierType: AccessibilityModifierType { CustomAccessibilityModifier.self }

    // expand base accessibility item with new parameters using string strategy
    var identifier: AccessibilityStringStrategy { get }
    var hintStrategy: AccessibilityStringStrategy { get }
}
```

By this way you can add any other functionality to accessibility items.

***

<br>

## Customize invalidation


### in table or collection
If you want to perform additional logic on invalidate, you can implement your own `AccessibilityItemInvalidator` and set `AccessibilityInvalidatorCreationBlock` 

**For example**
```swift

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .accessibility({ item, kind, delegate in
            return CustomInvalidator(item, kind, delegate)
        }))
        .build()
```

*Note that we have `DelegatedAccessibilityItemInvalidator` which could be used as base for your custom invalidator. This class is needed to combine strategies from item and generator.*

### in other view

Any view can implement `AccessibilityItem`, but you need adittionaly call `AccessibilityItem.modifySelf()` to setup accessibility-properties for real.

`AcessibilityInvalidatable.setBasicInvalidator` is also available for invalidation.

*Note that is recomended to call*
- `setBasicInvalidator` when view become **visible**
- `removeInvalidator` when view become **invisible**
