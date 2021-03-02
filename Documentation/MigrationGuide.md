# 7.0.0 MigrationGuide

## Deprecations

### Item protocols

`SelectableItem`, `DisplayableFlow`, `MovableGenerator` had a similar idea but not unified format. Thats why we introduced pattern `RDDM{ability}ableItem` and renamed all old protocols. We will remove old protocols in version *7.1.0*.

| Old                 | New                 |
| ------------------- | ------------------- |
| SelectableItem      | RDDMSelectableItem  |
| FoldableItem        | RDDMFoldableItem    |
| GravityFoldableItem | RDDMFoldableItem    |
| DisplayableFlow     | RDDMDisplayableItem |
| Gravity             | RDDMGravityItem     |
| MovableGenerator    | RDDMMovableItem     |

**Maybe useful** Just type `RDDM` and you will see all possible protocols bult-in framework.

### Managers

Long-named managers like `BaseTableDataDisplayManager` or `PaginableBaseTableDataDisplayManager` marked as deprecated.
Make attention to this deprecation warnings, because we will remove this managers in version *7.1.0*.

If you have inherite from `BaseTableDataDisplayManager` or other deprecated managers

 1. Check bult-in plugins. Maybe your `BaseTableDataDisplayManager` feature already transformed into plugin.
 2. Create plugin replacing your custom `BaseTableDataDisplayManager`
 3. Replace old manager initialisation with new builder like `tableView.rddm.baseBuilder.add(plugin: SomePlugin()).build()`

If you were using basic implemetation, just start from step 3.

**Keep in mind** that support of `RDDMSelectableItem` now was moved to `TableSelectablePlugin` and you should add this plugin to builder.

**Maybe useful** `tableView.add(plugin: .)` or `tableView.add(featurePlugin: .)` will produce autocomplete hints which can help you to inspect all bult-in plugins.

More about new entities and plugins system in [documentation](/Entities.md)

## Updates

### Base view reference

Previously we have `BaseTableDataDisplayManager.tableView` or `BaseCollectionDataDisplayManager.collection` properties with weak reference to view.

Now we have unified abstract `var view: CollectionType!` in protocol `DataDisplayManager` requirements.

 - Rename tableView -> view
 - Rename collection -> view
