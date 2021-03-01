# Entities overview

Basically `DataDisplayManager` contains such set of entities.

[![AbstractDataDisplayManager](https://i.ibb.co/rH9Kkp6/Abstract-Data-Display-Manager.png)](https://ibb.co/TtyDc08)

To simplify explanation of entities relationships we can mark each entity with atomic architecture terms.

[![Atomic Architecture](https://i.ibb.co/3cMwnjZ/2021-02-20-18-52-59.png)](https://ibb.co/L1JM3c7)

Greater component is more complex, and can directly or indirectly operate with smaller components.

**RECOMMENDATION** Interact, customize or extend atoms and moleculas when it possible and not greater entities.

## DataDisplayManager

`DataDisplayManager` protocol it is main *template* with client interface which operating with `generators`.

Concrete implementation with injected plugins is *page* in atomic terms.

### Example

In base implementation you can only add `generators` and reload collection.

But if your collection can change size dynamically, you need to choose between `Manual` and `Gravity` manager.

Assume you have such screen with two cells and horizontal scrolling content
```
Screen:
  Cell A:
    - item 1
    - item 2
    ...
  Cell B:
    - item 1
    - item 2
    ...
```

Each cell content is loading from separate endpoint. It means that sometimes cell A can be loaded first, and sometimes cell B. But cells order should always be the same.

Should we always wait loading of both sections before layout?

No

With `manual` approach

```swift

private lazy var ddm = tableView.rddm.manualBuilder.build()

private var generatorA: TableCellGenerator?
private var generatorB: TableCellGenerator?

func onContentALoaded(items: [ItemA]) {

  let generatorA = GeneratorA(items: items)

  if let generatorB = self.generatorB {
    ddm.insert(before: generatorB, new: [generatorA])
  } else {
    ddm.addCellGenerator(generatorA)
    ddm.forceRefill()
  }

  self.generatorA = generatorA
}

func onContentBLoaded(items: [ItemB]) {

  let generatorB = GeneratorB(items: items)

  if let generatorA = self.generatorA {
    ddm.insert(after: generatorA, new: [generatorB])
  } else {
    ddm.addCellGenerator(generatorB)
    ddm.forceRefill()
  }

  self.generatorB = generatorB
}

```

With `gravity` approach

```swift

private lazy var ddm = tableView.rddm.gravityBuilder.build()

func onContentALoaded(items: [ItemA]) {
  let generatorA = GeneratorA(items: items)
  ddm.addCellGenerator(generatorA)
  ddm.forceRefill()
}

func onContentBLoaded(items: [ItemB]) {
  let generatorB = GeneratorB(items: items)
  ddm.addCellGenerator(generatorB)
  ddm.forceRefill()
}

```

Secret in generators. Each `GravityGenerator` has property heaviness. This allow us to forget about sort order on fill stage.

In this example you can see differences between managing approaches and choose one for your needs.

`Manual` approach will be more useful in simple collections or when you updating cells based on user actions, like tap on plus button inside specific cell..

## Generator

- *Atom*
- Can build cells
- Can configure cells
- Can store closures or current cell state
- Stored inside `DataDisplayManager` and can cached to directly update concrete cell

`BaseCellGenerator` is your choice if you need display cell and process selection event.

This is generic generator with only one requirement to cell - conforming to `Configurable` protocol.

Recommended way to create generator `YourCellType.rddm.baseGenerator(with: model)` where model is `Configurable.Model` instance.

**NOTE** If you want store closures, current cell state or extend generator with some protocol, preferable extending `BaseCellGenerator` and not create your own.

### Example

Extending `BaseCellGenerator` to `FoldableItem`

```swift
final class FoldableCellGenerator: BaseCellGenerator<FoldableTableViewCell>, FoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [TableCellGenerator] = []

    // MARK: - Configuration

    override func configure(cell: FoldableTableViewCell, with model: FoldableTableViewCell.Model) {
        super.configure(cell: cell, with: model)

        didFoldEvent.addListner { isExpanded in
            cell.update(expanded: isExpanded)
        }
    }

}
```

### Errors

- `Could not load NIB in bundle ... with name 'YourCellName'`
This error appears because you are using class based cells (not UINib), but inside RDDM cells registering via UINib.

  **Your should override default registering in generator**
```swift
extension YourCellGenerator: TableCellGenerator {
  // ...

  func registerCell(in tableView: UITableView) {
      tableView.register(identifier, forCellReuseIdentifier: String(describing: identifier))
  }

  // ...
}
```

or simply fix initialising of your BaseGenerator using ` BaseCellGenerator.init(with: Cell.Model, registerType: .class)`

## Delegate

- *Organism*
- based on `UITableViewDelegate` or `UICollectionViewDelegate` (depends on collection type)
- Proxy collection events to plugins

### How to change

We hope, that bult-in delegate will cover 99% of your needs.

Btw you always can replace delegate with your own implementation.

**DO NOT FORGET** inherit BaseDelegate or add calls to plugins to not loose bult-in features.

`tableView.rddm.baseBuilder.set(delegate: YourCustomDelegate()).build()`

## DataSource

- *Organism*
- Based on `UITableViewDataSource` or `UICollectionViewDataSource` (depends on collection type)
- Implement `UITableViewDataSourcePrefetching` or `UICollectionViewDataSourcePrefetching` (depends on collection type)
- Proxy collection events to plugins

### How to change

We hope, that bult-in datasource will cover 99% of your needs.

Btw you always can replace datasource with your own implementation.

**DO NOT FORGET** inherit BaseDataSource or add calls to plugins to not loose bult-in features.

`tableView.rddm.baseBuilder.set(dataSource: YourCustomDataSource()).build()`

## PluginAction

- *Molecula*
- is represent reaction on collection event or events.
- Have access to manager. It means, that you have access to generators and can update collection from plugin.
- Injected in `PluginCollection` - simple list wrapper. It means, that on **each** event we can have **many** reactions (plugin-actions).
- can not return values to delegate or datasource

You can look at full list of proxy events in enums: `TableEvent`, `PrefetchEvent`, `CollectionEvent`, `ScrollEvent`.

### How to add

Simply add plugin in stage of building

`tableView.rddm.baseBuilder.add(plugin: YourCustomPlugin()).build()`

And conform generator to concrete `PluginAction.GeneratorType`

### Example

Handling rows selection.

```swift
public class TableSelectablePlugin: BaseTablePlugin<TableEvent> {

    typealias GeneratorType = SelectableItem

    public override init() {}

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard let selectable = manager?.generators[indexPath.section][indexPath.row] as? GeneratorType else {
                return
            }
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                manager?.view?.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }

}
```

More examples in bult-in plugins and example project.

## FeaturePlugin

- *Molecula*
- is implement part of delegate, datasource or both
- injected as **one** optional instance to avoid conflicts
- can return values to delegate or datasource

Basically this entity is adding fixed part of functionality like moving or dragging of cells.

### How to add

Simply set plugin in stage of building

`tableView.rddm.baseBuilder.set(plugin: TableMovablePlugin()).build()`

And conform generator to concrete `FeaturePlugin.GeneratorType`

### Examples

Look at `TableMovablePlugin`, `TableSectionTitleDisplayablePlugin` or `TableSwipeActionsConfigurationPlugin` and analogs for `UICollectionView`.

## Animator

Little atom created for approaches to animate collection changes.

`TableUpdatesAnimator` uses **beginUpdates/endUpdates** approach which will be deprecated soon.

`TableBatchUpdatesAnimator` uses **performBatchUpdates** approach which available since iOS 11.

Animator is selected based on iOS version, so most likely you never need to change this entity, but we've save such ability for you.

### How to change

Implement protocol `Animator` and set your implementation in builder

`tableView.rddm.baseBuilder.set(animator: YourCustomAnimator()).build()`
