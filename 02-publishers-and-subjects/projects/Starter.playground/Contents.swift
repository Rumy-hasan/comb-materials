/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.



import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/*
example(of: "Publisher") {
    let myNotification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default.publisher(for: myNotification, object: nil)
    
    let center = NotificationCenter.default

    let observer = center.addObserver(forName: myNotification, object: nil, queue: nil) { noti in
        print("It is called")
    }
    center.post(name: myNotification, object: nil)
    center.removeObserver(observer)
}
*/

/*
example(of: "Publisher") {
    let myNotification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default.publisher(for: myNotification, object: nil)
    let center = NotificationCenter.default
    let subscription = publisher.sink { _ in
        print("It is called")
    }
    center.post(name: myNotification, object: nil)
    subscription.cancel()
}
*/

/*
example(of: "Just") {
    let just = Just("Hellow World")
    _ = just.sink(receiveCompletion: {
        print("Received Completion: \($0)")
    }, receiveValue: {
        print("Received Value: \($0)")
    })
    _ = just.sink(receiveCompletion: {
        print("Received Completion (Other): \($0)")
    }, receiveValue: {
        print("Received Value (Other): \($0)")
    })
}
*/

/*
example(of: "assign(to:on:)") {
    class XYZ{
        var testValue = ""{
            didSet{
                print(testValue)
            }
        }
    }
    
    let obj = XYZ()
    let pub = ["Hello", "World"].publisher
    _ = pub.assign(to: \.testValue, on: obj)
    
}
*/

/*
example(of: "assign(to:)") {
    class SomeObject{
        @Published var value = 0
        deinit {
            print("call deinit")
        }
    }
    
    let obj = SomeObject()
    obj.$value.sink {
        print("The value is = ", $0)
    }
    (0...10).publisher.assign(to: &obj.$value)
}
*/


/*
var publisher = (1...6).publisher

final class IntSubscriber: Subscriber{
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value = ", input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received Completed \(completion)")
    }
    
    typealias Input = Int
    
    typealias Failure = Never
}

let subscriber = IntSubscriber()
publisher.subscribe(subscriber)
*/



/*
example(of: "Future") {
    func futureIncrement(integer: Int, after delay: TimeInterval) -> Future<Int, Never>{
        Future { promise in
            print("Origin")
            DispatchQueue.global().asyncAfter(deadline: .now()+delay) {
                promise(.success(integer+1))
            }
        }
    }
    
    let future = futureIncrement(integer: 1, after: 3)
    
    future.sink {
        print("completion = \($0)")
    } receiveValue: {
        print("Value = \($0)")
    }.store(in: &subscriptions)
    
    future.sink(receiveCompletion: { print("Second", $0) },
                receiveValue: { print("Second", $0) }).store(in: &subscriptions)
}
 
*/

/*
example(of: "PassthroughSubject") {
    enum MyError: Error{
        case test
    }
    
    final class StringSubscriber: Subscriber{
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            return input == "World" ? .max(1) : .none
        }
        
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = StringSubscriber()
    
    let subject = PassthroughSubject<String,MyError>()
    subject.subscribe(subscriber)
    
    let subscription = subject.sink { completion in
        print("Received completion (sink)", completion)
    } receiveValue: { value in
        print("Received value (sink)", value)
    }
    
    
    subject.send("Hello")
    subject.send("World")
    
    subscription.cancel()
    subject.send("Still there?")
    
    subject.send(completion: .failure(.test))
    subject.send(completion: .finished)
    subject.send("How about another one?")
}
 
 */


/*
example(of: "CurrentValueSubject") {
    // 1
    var subscriptions = Set<AnyCancellable>()
    // 2
    let subject = CurrentValueSubject<Int, Never>(0)
    // 3
    subject
        .print()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions) // 4
    
    subject.send(10)
    print(subject.value)
    
    subject.value = 3
    print(subject.value)
    
    subject
        .print()
        .sink(receiveValue: { print("Second subscription:", $0) }).store(in: &subscriptions)
}
*/

/*
example(of: "Dynamically adjusting Demand") {
    final class IntSubscriber: Subscriber{
        typealias Input = Int
        typealias Failure = Never
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value", input)
            switch input {
            case 1:
                return .max(2)
            case 3:
                return .max(1)
            default:
                return .none
            }
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = IntSubscriber()
    let subject = PassthroughSubject<Int,Never>()
    subject.subscribe(subscriber)
    
    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(4)
    subject.send(5)
    subject.send(6)
}
*/


example(of: "Type erasure") {
    let subject = PassthroughSubject<Int, Never>()
    let publisher = subject.eraseToAnyPublisher()
    publisher
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    subject.send(0)
}
