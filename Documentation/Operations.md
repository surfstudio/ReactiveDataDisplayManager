# Operations cheat sheet

| **Left**             | **Operation** | **Right**                        | **Result**                                            |
|----------------------|:-------------:|----------------------------------|-------------------------------------------------------|
| _DataDisplayManager_ |     **=>**    | _DataDisplayCommand.relod_       | `forceRefill()`                                       |
| _DataDisplayManager_ |     **-=**    | _SubstractionCommand.all_        | `clearCellGenerators()`                               |
| _DataDisplayManager_ |     **+=**    | Any _CellGeneratorType_ or Array | `addCellGenerators()`                                 |
| _DataDisplayManager_ |     **+=**    | Any _HeaderGeneratorType_        | `addSectionHeaderGenerator()`                         |
| _DataDisplayManager_ |     **+=**    | Any _FooterGeneratorType_        | `addSectionFooterGenerator()`                         |
| _CellGeneratorType_  |     **\***     | _HeaderGeneratorType_            | tuple of _Header_ with _Cells_                        |
| _DataDisplayManager_ |     **+=**    | tuple of _Header_ with _Cells_   | `addCellGenerators()` in concrete section             |
| _CellGeneratorType_  |     **\***     | _FooterGeneratorType_            | tuple of _Footer_ with _Cells_                        |
| _DataDisplayManager_ |     **+=**    | tuple of _Footer_ with _Cells_   | `addCellGenerators()` in concrete section             |
| _DataDisplayManager_ |     **+=**    | _Section_                        | `addCellGenerators()` with optional header and footer |
