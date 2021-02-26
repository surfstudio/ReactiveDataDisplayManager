# 7.0.0 MigrationGuide

## Deprecations

Long-named managers like `BaseTableDataDisplayManager` or `PaginableBaseTableDataDisplayManager` marked as deprecated.
Make attention to this deprecation warnings, because we will remove this managers in version *7.1.0*.

If you have inherite from `BaseTableDataDisplayManager` or other deprecated managers

 1. Check bult-in plugins. Maybe your `BaseTableDataDisplayManager` feature already transformed into plugin.
 2. Create plugin replacing your custom `BaseTableDataDisplayManager`
 3. Replace old manager initialisation with new builder like `tableView.rddm.baseBuilder.add(plugin: SomePlugin()).build()`

If you were using basic implemetation, just start from step 3.

**Keep in mind** that support of `SelectableItem` now was moved to `TableSelectablePlugin` and you should add this plugin to builder.

More about new entities and plugins system in [documentation](/Entities.md)

## Updates

### Base view reference

Previously we have `BaseTableDataDisplayManager.tableView` or `BaseCollectionDataDisplayManager.collection` properties with weak reference to view.

Now we have unified abstract `var view: CollectionType!` in protocol `DataDisplayManager` requirements.

 - Rename tableView -> view
 - Rename collection -> view
