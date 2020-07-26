//
//  ObservableType.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Observable interface. Observable gives the opportunity to listen any changes of specific object
public protocol ObservableType: class {
	associatedtype Element

	/// Converts current object to base Observable object
	func asObservable() -> Observable<Element>

	/// Subscribes for listening observable changes
	/// - Parameter observer: object that contains information about how to handle changes
	func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Value == Element
}
