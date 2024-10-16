import UIKit
import Combine

extension UICollectionView {
  
  /// A collection view specific `Subscriber` that receives `[[Element]]` input and updates a sectioned collection view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  public func sectionsSubscriber<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    cellConfig: @escaping CollectionViewItemsController<Items>.CellConfig<Items.Element.Element, CellType>
  )
  -> AnySubscriber<Items, Never> where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable {
    
    return sectionsSubscriber(.init(cellIdentifier: cellIdentifier, cellType: cellType, cellConfig: cellConfig))
  }
  
  /// A table view specific `Subscriber` that receives `[[Element]]` input and updates a sectioned table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  public func sectionsSubscriber<Items>(
    _ source: CollectionViewItemsController<Items>
  )
  -> AnySubscriber<Items, Never> where
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable {
    
    source.collectionView = self
    dataSource = source
    
    return AnySubscriber<Items, Never>(receiveSubscription: { subscription in
      subscription.request(.unlimited)
    }, receiveValue: { [weak self] items -> Subscribers.Demand in
      guard let self = self else { return .none }
      
      if self.dataSource == nil {
        self.dataSource = source
      }
      
      source.updateCollection(items)
      return .unlimited
    }) { _ in }
  }
  
  /// A table view specific `Subscriber` that receives `[Element]` input and updates a single section table view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  public func itemsSubscriber<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    cellConfig: @escaping CollectionViewItemsController<[Items]>.CellConfig<Items.Element, CellType>
  )
  -> AnySubscriber<Items, Never> where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items: Equatable {
    
    return itemsSubscriber(.init(cellIdentifier: cellIdentifier, cellType: cellType, cellConfig: cellConfig))
  }
  
  /// A table view specific `Subscriber` that receives `[Element]` input and updates a single section table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  public func itemsSubscriber<Items>(
    _ source: CollectionViewItemsController<[Items]>
  )
  -> AnySubscriber<Items, Never> where
  Items: RandomAccessCollection,
  Items: Equatable {
    
    source.collectionView = self
    dataSource = source
    
    return AnySubscriber<Items, Never>(receiveSubscription: { subscription in
      subscription.request(.unlimited)
    }, receiveValue: { [weak self] items -> Subscribers.Demand in
      guard let self = self else { return .none }
      
      if self.dataSource == nil {
        self.dataSource = source
      }
      
      source.updateCollection([items])
      return .unlimited
    }) { _ in }
  }
}


extension UICollectionView {
  /// A collection view specific `AsyncStream` that receives `[[Element]]` input and updates a sectioned collection view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  public func sectionsStream<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    stream: AsyncStream<Items>,
    cellConfig: @escaping CollectionViewItemsController<Items>.CellConfig<Items.Element.Element, CellType>
  ) where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable {
    sectionsStream(
      .init(
        cellIdentifier: cellIdentifier,
        cellType: cellType,
        cellConfig: cellConfig
      ), stream
    )
  }
  
  /// A table view specific `AsyncStream` that receives `[[Element]]` input and updates a sectioned table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  public func sectionsStream<Items>(
    _ source: CollectionViewItemsController<Items>,
    _ stream: AsyncStream<Items>
  ) where
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable
  {
    source.collectionView = self
    dataSource = source
    
    Task { @MainActor [weak self] in
      if let self {
        
        if self.dataSource == nil {
          self.dataSource = source
        }
        
        for await item in stream {
          source.updateCollection(item)
        }
      }
    }
  }
  
  /// A collection view specific `AsyncSequence` that receives `[[Element]]` input and updates a sectioned collection view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  @available(iOS 18.0, *)
  public func sectionsSequence<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    sequence: any AsyncSequence<Items, Never>,
    cellConfig: @escaping CollectionViewItemsController<Items>.CellConfig<Items.Element.Element, CellType>
  ) where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable {
    sectionsSequence(
      .init(
        cellIdentifier: cellIdentifier,
        cellType: cellType,
        cellConfig: cellConfig
      ), sequence
    )
  }
  
  /// A table view specific `AsyncSequence` that receives `[[Element]]` input and updates a sectioned table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  @available(iOS 18.0, *)
  public func sectionsSequence<Items>(
    _ source: CollectionViewItemsController<Items>,
    _ sequence: any AsyncSequence<Items, Never>
  ) where
  Items: RandomAccessCollection,
  Items.Element: RandomAccessCollection,
  Items.Element: Equatable
  {
    source.collectionView = self
    dataSource = source
    
    Task { @MainActor [weak self] in
      if let self {
        
        if self.dataSource == nil {
          self.dataSource = source
        }
        
        for await item in sequence {
          source.updateCollection(item)
        }
      }
    }
  }
  
  /// A table view specific `AsyncStream` that receives `[Element]` input and updates a single section table view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  public func itemsStream<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    stream: AsyncStream<[Items]>,
    cellConfig: @escaping CollectionViewItemsController<[Items]>.CellConfig<Items.Element, CellType>
  ) where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items: Equatable {
    return itemsStream(
      .init(
        cellIdentifier: cellIdentifier,
        cellType: cellType,
        cellConfig: cellConfig),
      stream
    )
  }
  
  /// A table view specific `AsyncStream` that receives `[Element]` input and updates a single section table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  public func itemsStream<Items>(
    _ source: CollectionViewItemsController<[Items]>,
    _ stream: AsyncStream<[Items]>
  ) where
  Items: RandomAccessCollection,
  Items: Equatable
  {
    source.collectionView = self
    dataSource = source
    
    Task { @MainActor [weak self] in
      if let self {
        
        if self.dataSource == nil {
          self.dataSource = source
        }
        
        for await items in stream {
          source.updateCollection(items)
        }
      }
    }
  }
  
  /// A table view specific `AsyncSequence` that receives `[Element]` input and updates a single section table view.
  /// - Parameter cellIdentifier: The Cell ID to use for dequeueing table cells.
  /// - Parameter cellType: The required cell type for table rows.
  /// - Parameter cellConfig: A closure that receives an initialized cell and a collection element
  ///     and configures the cell for displaying in its containing table view.
  @available(iOS 18.0, *)
  public func itemsSequence<CellType, Items>(
    cellIdentifier: String,
    cellType: CellType.Type,
    sequence: any AsyncSequence<[Items], Never>,
    cellConfig: @escaping CollectionViewItemsController<[Items]>.CellConfig<Items.Element, CellType>
  ) where
  CellType: UICollectionViewCell,
  Items: RandomAccessCollection,
  Items: Equatable {
    return itemsSequence(
      .init(
        cellIdentifier: cellIdentifier,
        cellType: cellType,
        cellConfig: cellConfig),
      sequence
    )
  }
  
  /// A table view specific `AsyncSequence` that receives `[Element]` input and updates a single section table view.
  /// - Parameter source: A configured `CollectionViewItemsController<Items>` instance.
  @available(iOS 18.0, *)
  public func itemsSequence<Items>(
    _ source: CollectionViewItemsController<[Items]>,
    _ sequence: any AsyncSequence<[Items], Never>
  ) where
  Items: RandomAccessCollection,
  Items: Equatable
  {
    source.collectionView = self
    dataSource = source
    
    Task { @MainActor [weak self] in
      if let self {
        
        if self.dataSource == nil {
          self.dataSource = source
        }
        
        for await items in sequence {
          source.updateCollection(items)
        }
      }
    }
  }
}
