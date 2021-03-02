## 7.0.0 Refactoring
### Added
- `Animator` protocol to isolate deprecated `begin/end updates`
- `PluginAction` protocol to handle simple actions with collection events
- `FeaturePlugin` protocol to extend collection manager with features quickly
- `CollectionBuilder` struct to build `CollectionManager`
- `TableBuilder` struct to build `TableManager`
- `rddm` namespace to quick access to manager builders

### Updated

- required `var view: CollectionType!` of `DataDisplayManager` protocol instead of required constructor
- abstract `Delegate` and `DataSource` is properties of `DataDisplayManager`

### Deprecated

- `BaseTableDataDisplayManager` class replaced with `ManualTableManager`
- `PaginableBaseTableDataDisplayManager` class will be removed at **7.1.**. Use `TableLastCellIsVisiblePlugin` instead.
- `ExtendableBaseTableDataDisplayManager` class will be removed at **7.1**. Part of `BaseTableManager` now.
- `GravityTableDataDisplayManager` class replaced with `GravityTableManager`
- `FoldingTableDataDisplayManager` class will be removed at **7.1.**. Use `TableFoldablePlugin` instead.
- `GravityFoldingTableDataDisplayManager` class will be removed at **7.1.**. Use composition of `GravityTableManager` and `TableFoldablePlugin`
- `SizableCollectionDataDisplayManager` class will be removed at **7.1.**. Part of `BaseCollectionManager`
- `BaseCollectionDataDisplayManager` replaced with `BaseCollectionManager`
- `SelectableItem`, `DisplayableFlow`, `MovableGenerator` and other item protocols will be removed at **7.1.**. Replaced with `RDDM{ability}ableItem` for example `RDDMSelectableItem`
