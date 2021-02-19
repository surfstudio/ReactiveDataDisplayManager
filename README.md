# ReactiveDataDisplayManager

[![Build Status](https://travis-ci.org/surfstudio/ReactiveDataDisplayManager.svg?branch=master)](https://travis-ci.org/surfstudio/ReactiveDataDisplayManager)
[![codebeat badge](https://codebeat.co/badges/30f4100b-ee0e-4bc6-8aad-c2128544c0c6)](https://codebeat.co/projects/github-com-surfstudio-reactivedatadisplaymanager-master) [![codecov](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager/branch/master/graph/badge.svg)](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager)

It is the whole approach to working with scrollable lists or collections.

TBD logo here (need designer help)

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
Just extend your cell to `Configurable` to fill subviews with model, when cell will be created.

```
import ReactiveDataDisplayManager

final class LabelCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

}

// MARK: - Configurable

extension LabelCell: Configurable {

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

```
final class ExampleTableController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(plugin: TableSelectablePlugin())
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

```
private extension MainTableViewController {

    func fill() {

        let models = ["First", "Second", "Third"]

        let generators = models.map { text -> BaseCellGenerator<LabelCell> in
            let generator = BaseCellGenerator<LabelCell>(with: text)

            generator.didSelectEvent += {
                // do some logic
            }

            return generator
        }

        ddm.addCellGenerators(generators)

        ddm.forceRefill()
    }

}
```

### Enjoy

As you can see, you don't need to conform `UITableViewDelegate` and `UITableViewDataSource`. This protocols are hidden inside ReactiveDataDisplayManager.
You can extend table functionality with adding plugins and replacing generator.
`Plugin + Generator = Feature`

You can check more examples in our [example project](/Example/) or in full [documentation](/Documentation/Entities.md)


## Installation

Just add ReactiveDataDisplayManager to your `Podfile` like this

```
pod 'ReactiveDataDisplayManager' ~> 7.0.0
```

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

For issues, file directly in the [main ReactiveDataDisplayManager repo](https://github.com/surfstudio/ReactiveDataDisplayManager).

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, solving a bug or adding a cool new feature), please review our [contribution guide](/Documentation/ContributingGuide.md) first and send us your pull request.

You PRs are always welcome.

## How to reach us

TBD

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
