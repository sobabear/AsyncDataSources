**AsyncDataSources** provides custom Combine subscribers and Concurrency AsyncStream/AsyncSequence that act as table and collection view controllers and bind a stream of element collections to table or collection sections with cells. Also Tried to build replace CombineDataSource which had led to unmaintained, crashable and concurrency-non-supported.

## Usage


#### Bind a plain list of elements

```swift
var data = PassthroughSubject<[Person], Never>()
var (dataStream, continuation) = AsyncStream<[Person]>.makeStream() 

data
  .bind(subscriber: tableView.rowsSubscriber(cellIdentifier: "Cell", cellType: PersonCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
  }))
  .store(in: &subscriptions)
  
// Same as on Conccurency

 tableView.rowsStream(
   cellIdentifier: "Cell", cellType: PersonCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
  }, dataStream
)
  
```

![Plain list updates with CombineDataSources](https://github.com/combineopensource/CombineDataSources/raw/master/Assets/plain-list.gif)

Respectively for a collection view:

```swift
data
  .bind(subscriber: collectionView.itemsSubscriber(cellIdentifier: "Cell", cellType: PersonCollectionCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
    cell.imageURL = URL(string: "https://api.adorable.io/avatars/100/\(model.name)")!
  }))
  .store(in: &subscriptions)
  
// Same as on Conccurency  
collectionView.itemsStream(cellIdentifier: "Cell", cellType: PersonCollectionCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
    cell.imageURL = URL(string: "https://api.adorable.io/avatars/100/\(model.name)")!
  }, dataStream
)
```

![Plain list updates for a collection view](https://github.com/combineopensource/CombineDataSources/raw/master/Assets/plain-collection.gif)

#### Bind a list of Section models

```swift
var data = PassthroughSubject<[Section<Person>], Never>()
var (dataStream, continuation) = AsyncStream<[Section<Person>]>.makeStream()

data
  .bind(subscriber: tableView.sectionsSubscriber(cellIdentifier: "Cell", cellType: PersonCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
  }))
  .store(in: &subscriptions)
  
// Same as on Conccurency

tableView.sectionsStream(cellIdentifier: "Cell", cellType: PersonCell.self, cellConfig: { cell, indexPath, model in
    cell.nameLabel.text = model.name
  }, dataStream
)
```

![Sectioned list updates with CombineDataSources](https://github.com/combineopensource/CombineDataSources/raw/master/Assets/sections-list.gif)

#### Customize the table controller

```swift
var data = PassthroughSubject<[[Person]], Never>()
var (dataStream, continuation) = AsyncStream<[[Person]]>.makeStream()

let controller = TableViewItemsController<[[Person]]>(cellIdentifier: "Cell", cellType: PersonCell.self) { cell, indexPath, person in
  cell.nameLabel.text = person.name
}
controller.animated = false

// More custom controller configuration ...

data
  .bind(subscriber: tableView.sectionsSubscriber(controller))
  .store(in: &subscriptions)
  
// Same as on Conccurency

tableView.sectionsStream(controller, dataStream)
```


## Installation

### Swift Package Manager

Add the following dependency to your **Package.swift** file:

```swift
.package(url: "https://github.com/sobabear/AsyncDataSources.git", from: "1.0.0")
```

## License

AsyncDataSources is available under the MIT license. See the LICENSE file for more info.



Inspired by [CombineDataSources](https://github.com/combineopensource/CombineDataSources),  [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) and [RxRealmDataSources](https://github.com/RxSwiftCommunity/RxRealmDataSources).

