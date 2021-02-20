# Entities overview

Basically `DataDisplayManager` contains such set of entities.

[![AbstractDataDisplayManager](https://i.ibb.co/rH9Kkp6/Abstract-Data-Display-Manager.png)](https://ibb.co/TtyDc08)

It is main organism with client interface which operating with `generators`.

## Generator

TBD

## Delegate

- Молекула. Заменяется лишь когда не получилось кастомизировать плагинами.
- Реализует **UITableViewDelegate** или аналог для коллекции.
- Может содержать в себе **PluginCollection** и набор **FeaturePlugin**
- При модификации следует либо наследоваться от **BaseTableDelegate**, либо реализовать протокол **TableDelegate**, сохранив поддержку плагинов.

### How to change

`tableView.rddm.baseBuilder.set(delegate: YourCustomDelegate()).build()`

## DataSource

- Молекула. Заменяется лишь когда не получилось кастомизировать плагинами.
- Реализует **UITableViewDataSource** и **UITableViewDataSourcePrefetching** или аналоги для коллекции.
- Может содержать в себе **PluginCollection** и набор **FeaturePlugin**
- При модификации следует либо наследоваться от **BaseTableDataSource**, либо реализовать протокол **TableDataSource**, сохранив поддержку плагинов.

### How to change

`tableView.rddm.baseBuilder.set(dataSource: YourCustomDataSource()).build()`

## PluginAction

- Атомарная единица. Основной инструмент при кастомизации.
- Описывает реакцию на событие коллекции.
- Имеет доступ до генераторов
- Собирается в **PluginCollection** - на одно событие может среагировать несколько плагинов

На основе этого можно проксировать события delegate или dataSource, добавить реакцию на нажатия для **SelectableItem**  или разворот по нажатию для **FoldableItem**.
Можно ознакомиться с готовыми плагинами в Example проекте.

### How to add

`tableView.rddm.baseBuilder.add(plugin: TableSelectablePlugin()).build()`

### Example
```swift
public class TableSelectablePlugin: BaseTablePlugin<TableEvent> {

    public override init() {}

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard let selectable = manager?.generators[indexPath.section][indexPath.row] as? SelectableItem else {
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

`tableView.rddm.baseBuilder.set(plugin: TableMovablePlugin()).build()`


## Animator

- Атом отвечающий за анимацию операций вставки или удаления

Эта сущность нужна для возможности сменить метод анимации таблицы.
C **beginUpdates/endUpdates** (deprecated) на **performBatchUpdates** или с использованием стронних библиотек.
По-умолчанию будет выбираться **TableBatchUpdatesAnimator** если  таргет = iOS 11.

### How to change

`tableView.rddm.baseBuilder.set(animator: TableBatchUpdatesAnimator()).build()`
