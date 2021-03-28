# Swift Package Manager support

## Usage

Example of using the RDDM in a SPM.

### ConfigurableItem

`ConfigurableItem` has a method to support spm.
To use a cell inside a Package, you need to call the `bundle()` method and return `Bundle.module`

```swift
import ReactiveDataDisplayManager

final class LabelCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

}

// MARK: - ConfigurableItem

extension LabelCell: ConfigurableItem {

    typealias Model = String

    func configure(with model: Model) {
        titleLabel.text = model
    }
    
    func bundle() -> Bundle {
        return Bundle.module 
    }
}
```
For correct work, you must specify your SPM module for all `.xib` files and `.storyboard`.
In all views related to `.xib` (for example headers), you also need to specify `Bundle.module` manually.

## Installation

Just add ReactiveDataDisplayManager dependency to your Package like this

```
let package = Package(
    name: "ExamplePackage",
    defaultLocalization: "ru",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ExamplePackage",
            targets: ["ExamplePackage"]),
    ],
    dependencies: [
        .package(name: "ReactiveDataDisplayManager",
                 url: "https://github.com/surfstudio/ReactiveDataDisplayManager",
                 .branch("branch-name")
        )
    ],
    targets: [
        .target(
            name: "ExamplePackage",
            dependencies: ["ReactiveDataDisplayManager"])
    ]
)
```
