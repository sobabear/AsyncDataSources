import Foundation
import Combine

public extension Publisher where Failure == Never {
  func bind<B: Subscriber>(subscriber: B) -> AnyCancellable
  where B.Failure == Never, B.Input == Output {
    
    handleEvents(receiveSubscription: { subscription in
      subscriber.receive(subscription: subscription)
    })
    .sink { value in
      _ = subscriber.receive(value)
    }
  }
}
