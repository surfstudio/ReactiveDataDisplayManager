## 7.2.0 Fix DiffableDataSource and plugins
### Added
- tvOS example with collection #132
- missed suplementary provider which may cause crash #141
- method `scrollTo` concrete generator #142
- strategies for `DragAndDroppable` #144
- examples of some custom `UICollectionViewLayout` #146

### Updated

- `DiffableItemSource` and `DragAndDropableItemSource` to avoid naming conflict #145
- access modifiers of parts in `DragAndDroppable` #145
- `TableDiffableModifier` and `CollectionDiffableModifier` to fix dataSource conflicts
- color of paginator in example
