[![Build Status](https://travis-ci.org/surfstudio/ReactiveDataDisplayManager.svg?branch=master)](https://travis-ci.org/surfstudio/ReactiveDataDisplayManager)
[![codebeat badge](https://codebeat.co/badges/30f4100b-ee0e-4bc6-8aad-c2128544c0c6)](https://codebeat.co/projects/github-com-surfstudio-reactivedatadisplaymanager-master) [![codecov](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager/branch/master/graph/badge.svg)](https://codecov.io/gh/surfstudio/ReactiveDataDisplayManager)

# ReactiveDataDisplayManager
It is the whole approach to working with UITableView.
The main idea of RDDM is to make development of table screen faster and clearly. So it provide reuse DDM and reuse cells both within a project and beetween projects.

# Entites
RDDM contains next entites:        
 - **TableDataDisplayManager**: This is something like adapter. This entity responses for add, remove, swap cells in `UITableView`. Also for fill table, reload data and other functionality, provided with `UITableViewDelegate` and `UITableViewDataSource`.
 - **ViewGenerator**: This entity is aspect of more difficult object. But exactly this entity provide interface to **TableDataDisplayManager** for store each similar objects in collection and get `UIView` for create SectionHeader.
 - **TableCellGenerator**: This entity is something like **ViewGenerator**. It reponse for create `UITableViewCell` for **TableDataDisplayManager**. In this way this **Generator** hide the concretate cell type from **TDDM** and show it only the abstract cell - `UITableViewCell`.
 - **ViewBuilder<ViewType>**: This object incapsulate logicks for fill view with model that needs to display. This object together with **TableCellGenerator** (or **ViewGenerator**) is a part of more difficult object.

Object which implement **ViewBuilder** and **TableCellGenerator** (or **ViewGenerator**), I called just **Generator**.
And this object also response for events (notify listners) and response for store model. Usually view create generators, subscribe on events and send them to **TDDM**.

```swift
class SubscriptionServiceGenerator {

    // MARK: - Events

    public var buyEvent: BaseEvent<PaidService>

    // MARK: - Stored properties

    fileprivate let model: PaidService?

    // MARK: - Initializer

    public init(model: PaidService?) { <#code#> }
}

// MARK: - TableCellGenerator

extension SubscriptionServiceGenerator: TableCellGenerator {
    var identifier: UITableViewCell.Type {
        return SubscriptionServiceCell.self // it cocnreate cell
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier.nameOfClass, for: indexPath) as? SubscriptionServiceCell else { return UITableViewCell() }

        self.build(view: cell)

        return cell
    }
}

// MARK: - ViewBuilder

extension SubscriptionServiceGenerator: ViewBuilder {

    func build(view: SubscriptionServiceCell) {
        view.delegate = self
        <# some logics #>
    }
}

// MARK: - SubscriptionServiceCellDelegate

extension SubscriptionServiceGenerator: SubscriptionServiceCellDelegate {

    func subscribtionButtonTouchid(in cell: SubscriptionServiceCell) {
        guard let service = self.model else { return }
        self.buyEvent.invoke(with: service)
    }
}
```
 - **Event**: is custom object, that may store closures, which have the same signatures, object that store an avent may call all stored closures for send objects, that provide this closures about event.

View wants to recive a message about user tap on button:
```swift
 var generator = SubscriptionServiceGenerator(model: service)
 generator.buyEvent += { (service: PaidService) -> Void in
    <# do something #>
 }
```

## How to install

`pod 'ReactiveDataDisplayManager' ~> 4.0.0`

## Errors

- `Could not load NIB in bundle ... with name 'YourCellName'`
This error appears because you are using class based cells (not UINib), but inside RDDM cells registering via UINib.

  **Your should override default registering in generator**
```swift
extension YourCellGenerator: TableCellGenerator {
  // ...

  func registerCell(in tableView: UITableView) {
      tableView.register(identifier, forCellReuseIdentifier: String(describing: identifier))
  }

  // ...
}
```

## Versioning

Version format is `x.y.z` where
- x is major version number. Bumped only in major updates (implementaion changes, adding new functionality)
- y is minor version number. Bumped only in minor updates (interface changes)
- z is minor version number. Bumped in case of bug fixes and e.t.c.
