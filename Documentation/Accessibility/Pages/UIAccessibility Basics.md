[⏎ Overview](../Overview.md)

# `UIAccessibility` Basics
- [`isAccessibilityElement`](#isaccessibilityelement)
- [`accessibilityElements`](#accessibilityelements)
- [`accessibilityLabel`](#accessibilitylabel)
- [`accessibilityValue`](#accessibilityvalue)
- [`accessibilityTraits`](#accessibilitytraits)
- [`accessibilityCustomActions`](#accessibilitycustomcctions)
- [`accessibilityActivationPoint`](#accessibilityactivationPoint)
- [`accessibilityViewIsModal`](#accessibilityviewismodal)
- [`func accessibilityActivate()`](#func-accessibilityactivate)
- [`func accessibilityIncrement()`](#func-accessibilityincrement)
- [`func accessibilityDecrement()`](#func-accessibilitydecrement)
- [`func accessibilityPerformEscape()`](#func-accessibilityperformescape)
- [`UIAccessibility.isVoiceOverRunning`](#uiaccessibilityisvoiceoverrunning)
- [`UIAccessibility.post(notification:, argument:)`](#uiaccessibilitypostnotification-argument)

***
## `isAccessibilityElement`

```swift
var isAccessibilityElement: Bool
```
Defines accessibility view, that can be selected with VoiceOver. No other of its subviews can be selected

***
## `accessibilityElements`

```swift
var accessibilityElements: [Any]?
```
Defines an array and order of container's accessibility elements.
Can be used instead of dynamic methods `accessibilityElementsCount()` and `accessibilityElement(at index:)`

***
## `accessibilityLabel`
```swift
var accessibilityLabel: String?
```
The "name" of accessibility element. Always read by VoiceOver. For labels and buttons it's equals to title.

***
## `accessibilityValue`
```swift
var accessibilityValue: String?
```
Contains the value of element, can be read multiple times when it updates and has a trait `.updatesFrequently`.

***
## `accessibilityTraits`
```swift
var accessibilityTraits: UIAccessiblityTraits
```
Describes how an accessibility element behaves or how to treat it.

- `.button` - element is a button and has an action. This is default trait for all buttons. Can be activated by double tap. See [activate method](#func-accessibilityactivate).
- `.staticText` - element is a static text, that wouldn't change. This is default trait for all labels.
- `.header` - marks and pronounced by VoiceOver that current element is header of some view structure. 
- `.selected` - marks and pronounced by VoiceOver that current element is in selected state. Automatically added for selected cells.
- `.notEnabled` - marks and pronounced by VoiceOver that current element is in disabled state. Automatically added for disables controls.
- `.adjustable` - element is a contol that can be manipulated by swipes, for example slider or segmented controll. By default only slider owns this trait. See [increment](#func-accessibilityincrement) and [decrement](#func-accessibilitydecrement) methods.
- `.updatesFrequently` - marks that current element frequently updates its label or value and schedule notifications for it.

Resources: 
- https://mobilea11y.com/blog/traits/

***
## `accessibilityCustomActions`
```swift
var accessibilityCustomActions: [UIAccessibilityCustomAction]?
```
Provides custom actions for element that can be activated by user.

***
## `accessibilityActivationPoint`
```swift
var accessibilityActivationPoint: CGPoint
```
A point for `.touchUpInside` event. Measured in screen coordinates.

***
## `accessibilityViewIsModal`
```swift
var accessibilityViewIsModal: Bool
```
Defines a view is modal to ignore other views in a widnow.

***
## `func accessibilityActivate()`
```swift
func accessibilityActivate() -> Bool
```
Called when accessibility element wtih `.button` trait is activated. Can be used when element has no `.touchUpInside` handlers.

***
## `func accessibilityIncrement()`
```swift
func accessibilityIncrement() -> Bool
```
Called when accessibility element has trait `.adjustable` and performs increment action.

***
## `func accessibilityDecrement()`
```swift
func accessibilityDecrement() -> Bool
```
Called when accessibility element has trait `.adjustable` and performs decrement action.

***
## `func accessibilityPerformEscape()`
```swift
func accessibilityPerformEscape() -> Bool
```
Called when user performs the special gesture to dismiss the modal view.

***
## `UIAccessibility.isVoiceOverRunning`
```swift
static var isVoiceOverRunning: Bool { get }
```
Defines VoiceOver running state. 

***
## `UIAccessibility.post(notification:, argument:)`
```swift
 UIAccessibility.post(notification: UIAccessibility.Notification, argument: Any?) 
```
Method that can manipulate VoiceOver's focus or make announcements for user. There are different types of notifications:
- `.announcement` - a simple notification with argument `String`, that be announced
- `.layoutChanged` - posted when big layout changes occures, updates accessibility elements hierarchy. Can be specified with argument which is accessibility element to move focus on it.
- `.screenChanged` - posted when screen is changed, updates accessibility elements hierarchy. Can be specified with argument which is accessibility element to move focus on it.
