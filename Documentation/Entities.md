TBD translate

## Сущности

Готовый **DataDisplayManager** может содержать в себе множество сущностей.  
По уровню сложности можем считать его организмом. Наследоваться от него потребуется в крайнем случае.

![AbstractDataDisplayManager](AbstractDataDisplayManager.png)

### PluginAction

- Атомарная единица. Основной инструмент при кастомизации.
- Описывает реакцию на событие коллекции.
- Имеет доступ до генераторов
- Собирается в **PluginCollection** - на одно событие может среагировать несколько плагинов

На основе этого можно проксировать события delegate или dataSource, добавить реакцию на нажатия для **SelectableItem**  или разворот по нажатию для **FoldableItem**.
Можно ознакомиться с готовыми плагинами в Example проекте.

#### Пример подключения

`tableView.rddm.baseBuilder.add(plugin: TableSelectablePlugin()).build()`

#### Пример реализации
```
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

### FeaturePlugin

- Атомарная единица. Основной инструмент при кастомизации.
- Представляет собой протокол для отдельной части dataSource или delegate.
- Интегрируется в единственном экземпляре

На основе этого типа сущности можно добавить поддержку перетаскивания ячеек, поддержку алфавитного указателя.
Когда фича требует задействование нескольких методов dataSource или delegate с возвращаемым значением - FeaturePlugin ваш выбор.

#### Пример подключения

`tableView.rddm.baseBuilder.set(plugin: TableMovablePlugin()).build()`

#### Пример реализации
TODO

### Delegate

- Молекула. Заменяется лишь когда не получилось кастомизировать плагинами.
- Реализует **UITableViewDelegate** или аналог для коллекции.
- Может содержать в себе **PluginCollection** и набор **FeaturePlugin**
- При модификации следует либо наследоваться от **BaseTableDelegate**, либо реализовать протокол **TableDelegate**, сохранив поддержку плагинов.

#### Пример подключения

`tableView.rddm.baseBuilder.set(delegate: YourCustomDelegate()).build()`

### DataSource

- Молекула. Заменяется лишь когда не получилось кастомизировать плагинами.
- Реализует **UITableViewDataSource** и **UITableViewDataSourcePrefetching** или аналоги для коллекции.
- Может содержать в себе **PluginCollection** и набор **FeaturePlugin**
- При модификации следует либо наследоваться от **BaseTableDataSource**, либо реализовать протокол **TableDataSource**, сохранив поддержку плагинов.

#### Пример подключения

`tableView.rddm.baseBuilder.set(dataSource: YourCustomDataSource()).build()`

### Animator

- Молекула отвечающая за вставку и удаление ячеек
- Оперирует только **IndexPath**

Эта сущность нужна для возможности сменить метод анимации таблицы. C **beginUpdates/endUpdates** на **performBatchUpdates** или с использованием стронних библиотек.
Выделение этой сущности в процессе разработки.

#### Пример подключения

`tableView.rddm.baseBuilder.set(animator: YourCustomAnimator()).build()`
