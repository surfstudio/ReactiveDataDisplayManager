# Entities overview

Basically `DataDisplayManager` contains such set of entities.

[![AbstractDataDisplayManager](https://i.ibb.co/rH9Kkp6/Abstract-Data-Display-Manager.png)](https://ibb.co/TtyDc08)

## Manager

It is main template with client interface which operating with `generators`.

### Example

TBD Manual

TBD Gravity

## Generator

- Atom
- Can build cells
- Can configure cells
- Can store closures or current cell state
- Stored inside `DataDisplayManager` and can cached to directly update concrete cell

`BaseCellGenerator` is your choice if you need display cell and process selection event.

This is generic generator with only one requirement to cell - conforming to `Configurable` protocol.

Recommended way to create generator `YourCellType.rddm.baseGenerator(with: model)` where model is `Configurable.Model` instance.

*NOTE* If you want store closures, current cell state or extend generator with some protocol, preferable extending `BaseCellGenerator` and not create your own.

### Example

Extending `BaseCellGenerator` to `FoldableItem`

```swift

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

## Delegate

- Organism
- based on `UITableViewDelegate` or `UICollectionViewDelegate` (depends on collection type)
- Proxy collection events to plugins

### How to change

We hope, that bult-in delegate will cover 99% of your needs.

Btw you always can replace delegate with your own implementation.

*DO NOT FORGET* inherit BaseDelegate or add calls to plugins to not loose bult-in features.

`tableView.rddm.baseBuilder.set(delegate: YourCustomDelegate()).build()`

## DataSource

- Organism
- Based on `UITableViewDataSource` or `UICollectionViewDataSource` (depends on collection type)
- Implement `UITableViewDataSourcePrefetching` or `UICollectionViewDataSourcePrefetching` (depends on collection type)
- Proxy collection events to plugins

### How to change

We hope, that bult-in datasource will cover 99% of your needs.

Btw you always can replace datasource with your own implementation.

*DO NOT FORGET* inherit BaseDataSource or add calls to plugins to not loose bult-in features.

`tableView.rddm.baseBuilder.set(dataSource: YourCustomDataSource()).build()`

## PluginAction

- Атомарная единица. Основной инструмент при кастомизации.
- Описывает реакцию на событие коллекции.
- Имеет доступ до генераторов
- Собирается в **PluginCollection** - на одно событие может среагировать несколько плагинов

На основе этого можно проксировать события delegate или dataSource, добавить реакцию на нажатия для **SelectableItem**  или разворот по нажатию для **FoldableItem**.
Можно ознакомиться с готовыми плагинами в Example проекте.

### How to add

Simply add plugin in stage of building

`tableView.rddm.baseBuilder.add(plugin: TableSelectablePlugin()).build()`

And conform generator to concrete `PluginAction.GeneratorType`

### Example

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

## FeaturePlugin

- Атомарная единица. Основной инструмент при кастомизации.
- Представляет собой протокол для отдельной части dataSource или delegate.
- Интегрируется в единственном экземпляре

На основе этого типа сущности можно добавить поддержку перетаскивания ячеек, поддержку алфавитного указателя.
Когда фича требует задействование нескольких методов dataSource или delegate с возвращаемым значением - FeaturePlugin ваш выбор.

### How to add

Simply add plugin in stage of building

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

`tableView.rddm.baseBuilder.set(animator: TableBatchUpdatesAnimator()).build()`
