## 7.3 Test coverage and bug-fixing
### Added
- Missed public init for Empty Header/Footer generators
- Entry for baseNonReusable
- Warnings and assertion failures for unused or misconfigured plugins
- **New item** to automate updating of resizable cells - `ExpandableItem`
- **New feature** Multiple drag-n-drop
- **Code coverage** from UI and Unit tests

### Updated
- Example of usage RDDM in tvOS
- Model of project generation

### Fixed
- Configuration of Example blocking development on Apple Silicon


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
