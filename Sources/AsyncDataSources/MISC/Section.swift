import Foundation
import UIKit

public protocol SectionProtocol {
  associatedtype Item
  
  var header: String? { get }
  var footer: String? { get }
  var items: [Item] { get }
}

public struct Section<Item: Hashable>: SectionProtocol, Identifiable {
  public init(header: String? = nil, items: [Item], footer: String? = nil, id: String? = nil) {
    self.id = id ?? header ?? UUID().uuidString
    self.header = header
    self.items = items
    self.footer = footer
  }
  
  public let id: String
  
  public let header: String?
  public let footer: String?
  public let items: [Item]
}


extension Section: Equatable {
  public static func == (lhs: Section<Item>, rhs: Section<Item>) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Section: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Section: RandomAccessCollection {
  public var startIndex: Int {
    return items.startIndex
  }
  
  public var endIndex: Int {
    return items.endIndex
  }
  
  public func index(after i: Int) -> Int {
    return items.index(after: i)
  }
  
  public subscript(index: Int) -> Item {
    return items[index]
  }
  
  public subscript(safe index: Int) -> Item? {
    return items[safe: index]
  }
  
  public var count: Int {
    return items.count
  }
}

private extension Collection {
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
