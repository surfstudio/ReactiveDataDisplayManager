## 7.1.0 SPM support and new plagins
### Added
- Swift Package Manager support with example
- example of usage `CompositionalLayout`
- example of usage `DifferenceKit`
- `DiffableTableDataSource` implementing `UICollectionTableDataSource`
- `DiffableCollectionDataSource` implementing `UICollectionDiffableDataSource`
- `CollectionSwipeActionsConfigurationPlugin` to support `UISwipeActionsConfiguration` in collection with list appearance
-

### Updated

- code style and linter issues fixes 
- documentation and typos

### Deprecated

- `BaseTableDataDisplayManager` class replaced with `ManualTableManager`
- `PaginableBaseTableDataDisplayManager` class will be removed at **8.0.**. Use `TableLastCellIsVisiblePlugin` instead.
- `ExtendableBaseTableDataDisplayManager` class will be removed at **8.0**. Part of `BaseTableManager` now.
- `GravityTableDataDisplayManager` class replaced with `GravityTableManager`
- `FoldingTableDataDisplayManager` class will be removed at **8.0.**. Use `TableFoldablePlugin` instead.
- `GravityFoldingTableDataDisplayManager` class will be removed at **8.0.**. Use composition of `GravityTableManager` and `TableFoldablePlugin`
- `SizableCollectionDataDisplayManager` class will be removed at **8.0.**. Part of `BaseCollectionManager`
- `BaseCollectionDataDisplayManager` replaced with `BaseCollectionManager`
- `SelectableItem`, `DisplayableFlow`, `MovableGenerator` and other item protocols will be removed at **8.0.**. Replaced with `{ability}ableItem` for example `SelectableItem`
