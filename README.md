# ReactiveDataDisplayManager

[![Build](https://github.com/surfstudio/ReactiveDataDisplayManager/actions/workflows/Build.yml/badge.svg)](https://github.com/surfstudio/ReactiveDataDisplayManager/actions/workflows/Build.yml)
[![codebeat badge](https://codebeat.co/badges/aa8b4a6a-970f-4e1b-8400-bfe902f8aa68)](https://codebeat.co/projects/github-com-surfstudio-reactivedatadisplaymanager-develop)
[![codecov](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager/branch/master/graph/badge.svg)](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager)

It is the whole approach to working with scrollable lists or collections.

[![Logo](https://i.ibb.co/zs8P9c3/716-225-Reactive-Logo.jpg)](https://ibb.co/Q98YSBW)

## About

This Framework was made to speed up development of scrollable collections like UITableView or UICollectionView, and to provide new way to easy extend collections functionality.

## Breaking changes

We made a massive refactoring with version 7.0.0.
Please read our [migration guide](/Documentation/MigrationGuide.md) if you were using version 6 or older.

## Currently supported features

- Populating cells without implementing delegate and datasource by yourself
- Inserting, replacing or removing cells without reload
- Expanding and collapsing cells inside collection
- Moving or Drag'n'Drop cells inside collection
- Customizing of section headers and index titles

## Usage

Step by step example of configuring simple list of labels.

### Prepare cell

You can layout your cell from xib or from code. It doesn't matter.
Just extend your cell to `ConfigurableItem` to fill subviews with model, when cell will be created.

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
}
```

### Prepare collection

Just call `rddm` from collection
- add plugins for your needs
- build your ReactiveDataDisplayManager

```swift
final class ExampleTableController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fill()
    }

}
```

### Fill collection

Convert models to generators and call `ddm.forceRefill()`

```swift
private extension MainTableViewController {

    func fill() {

        let models = ["First", "Second", "Third"]

        for model in models {
            let generator = TitleTableViewCell.rddm.baseGenerator(with: model)

            generator.didSelectEvent += { [weak self] in
                // do some logic
            }

            // Add generator to adapter
            ddm.addCellGenerator(generator)
        }

        ddm.forceRefill()
    }

}
```

### Enjoy

As you can see, you don't need to conform `UITableViewDelegate` and `UITableViewDataSource`. This protocols are hidden inside ReactiveDataDisplayManager.
You can extend table functionality with adding plugins and replacing generator.

[![Feature](https://i.ibb.co/WFrzQNK/2021-02-20-15-52-34.png)](https://ibb.co/mtnymrz)

You can check more examples in our [example project](/Example/) or in full [documentation](/Documentation/Entities.md)


## Installation

Just add ReactiveDataDisplayManager to your `Podfile` like this

```
pod 'ReactiveDataDisplayManager' ~> 7.3
```

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

For issues, file directly in the [main ReactiveDataDisplayManager repo](https://github.com/surfstudio/ReactiveDataDisplayManager).

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, solving a bug or adding a cool new feature), please review our [contribution guide](/Documentation/ContributingGuide.md) first and send us your pull request.

You PRs are always welcome.

## License

[MIT License](LICENSE)
