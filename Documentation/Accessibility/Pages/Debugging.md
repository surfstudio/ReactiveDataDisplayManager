[⏎ Overview](../Overview.md)

# Debugging

## Accessibility Inspector

Accessibility Inspector is an instrument provided with Xcode, so this is most common insturment to see accessibility parameters. It can be opened in Menu Bar: `Xcode -> Open Developer Tool -> Accessibility Inspector`.

<img src="https://i.ibb.co/wMkh1rG/2023-06-16-16-25-02.png" alt="Accessibility Inspector">

Here you can see common acceessibility parameters and perform accessibility actions. To select an element you need fisrt select a running simulator. Then you click target button on the right and select an element or click arrorws "<" and ">" to navigate through all elements. Optionally, you can enable reading for selected elements.

Be aware that not all accessibility parameters are displayed as they VoiceOver is reading. For example, if the element is `UISwitch`, in inspector you can see values 0 or 1, but VoiceOver will localize these values into "enabled" and "disabled". So it's better to also check elements with VoiceOver.

*Note: Accessibility parameters also can be seen in a view debugger, but it's non interactive.*
<img src="https://i.ibb.co/RQxVPGg/2023-06-16-16-32-20.png" alt="View Debugger">

***

<br>

## Accessibility Audit

Accessibility Inspector allows you to run audit of current screen to find and different accessibility issues if they exists. The second tab in right corner navigates you to audit window.

<img src="https://i.ibb.co/LPfx62N/2023-06-16-16-57-17.png" alt="Accessibility Audit">

***

<br>

## VoiceOver

If you will test your app on a device with VoiceOver you can enable some useful options.

<img src="https://i.ibb.co/TWJGG77/2023-06-16-17-07-42.jpg" alt="Caption Panel" width=49%>
<img src="https://i.ibb.co/8Prs6r6/2023-06-16-17-07-17.jpg" alt="Accessibility Shortcut" width=49%>

Caption panel allows you to read instead of listen to VoiceOver. And Accessibility Shortcut allows you to fast enable or disable VoiceOver by triple-click the lock button.

It also useful to read an article how to use VoiceOver gestures https://support.apple.com/guide/iphone/iph3e2e2281/ios

***

<br>

## UI Tests

Accessibility elements are also used for UI tests. So changing traits affects on `XCUIElement` type (any element with trait `.button` becomes a button `XCUIElement`).

If you manually change collection or table classes to become an accessibility elements your UI tests may fail, if they will not contains required accessibility.

<img src="https://i.ibb.co/gz049gW/2023-06-16-17-31-51.png" alt="UI test failure">

To fix this issue **RDDM** provides a built-in modifier for UI tests. You only need to provide the command line argument `"-rddm.XCUITestsCompatible"`

<img src="https://i.ibb.co/XbzffYF/2023-06-16-17-36-30.png" alt="UI tests modifier">

This modifier will add traits `.button` to all cells and `.staticText` to all headers and footers to prevent UI tests failures.

***

<br>

## UI Tests Accessibility Audit

In Xcode 15 you can run automatic accessibility audit with just a line of code:

```swift
try app.performAccessibilityAudit()
```

It's the same audit from Accessibility Inspector. If there will be any issues test will fail and you can see these issues in logs. See more at https://developer.apple.com/videos/play/wwdc2023/10035/.

<br>

Next [Advanced Usage →](./Advanced%20Usage.md)