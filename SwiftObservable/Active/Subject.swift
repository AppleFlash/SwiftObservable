//
//  Subject.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Read-write object. Allows listen changes and cause them
public final class Subject<Element>: Observable<Element> {
	private lazy var observers: [UUID: AnyObserver<Value>] = [:]

	/// Current value of observable object
	public var value: Element {
		didSet {
			process(value)
		}
	}

	public init(value: Element) {
		self.value = value
	}

	public override func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Observer.Value == Element {
		let id = UUID()
		observers[id] = AnyObserver(observer)
		observer.process(value)

		return Disposable { [weak self] in
			self?.observers[id] = nil
		}
	}
}

extension Subject: ObserverType {
	public func process(_ value: Element) {
		observers.forEach { $0.value.process(value) }
	}
}
