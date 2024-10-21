import Foundation

extension AsyncStream {
  public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
    let lock = NSLock()
    var iterator: S.AsyncIterator?
    self.init {
      lock.withLock {
        if iterator == nil {
          iterator = sequence.makeAsyncIterator()
        }
      }
      return try? await iterator?.next()
    }
  }
  
#if swift(<5.9)
  public static func makeStream(
    of elementType: Element.Type = Element.self,
    bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
  ) -> (stream: Self, continuation: Continuation) {
    var continuation: Continuation!
    return (Self(elementType, bufferingPolicy: limit) { continuation = $0 }, continuation)
  }
#endif
  
  public static var never: Self {
    Self { _ in }
  }
  
  public static var finished: Self {
    Self { $0.finish() }
  }
}

extension AsyncSequence {
  public func eraseToStream() -> AsyncStream<Element> {
    AsyncStream(self)
  }
}
