## 7.2.1 SelectableItem fixes and minor improvements
### Added
- `didDeselectEvent` to `SelectableItem`
- new plugin `Focusable` for `UITableView` and `UICollectionView` to customise cells selection at **tvOS**

### Updated

- UI of Example project

### Fixed

- navigation bug in Example project
- property `isNeedDeselect` in `SelectableItem` is always **true**
- failing at *index out of bounds* exception at `DragnDropablePlugin`
