//
//  Filter.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

extension ObservableType {
	func filter(_ closure: @escaping (Element) -> Bool) -> Observable<Element> {
		return FilterObservable(source: self.asObservable(), filterClosure: closure)
	}
}

private final class FilterObservable<Element>: Observable<Element> {
	private final class FilterTransformer<Observer: ObserverType>: ObserverType {
		private let observer: Observer
		private let observable: FilterObservable<Observer.Value>

		init(observer: Observer, observable: FilterObservable<Observer.Value>) {
			self.observer = observer
			self.observable = observable
		}

		func process(_ value: Observer.Value) {
			guard observable.filterClosure(value) else { return }

			observer.process(value)
		}
	}

	let filterClosure: (Element) -> Bool
	private let source: Observable<Element>

	init(source: Observable<Element>, filterClosure: @escaping (Element) -> Bool) {
		self.filterClosure = filterClosure
		self.source = source
	}

	override func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Element == Observer.Value {
		return source.subscribe(
			FilterTransformer(observer: observer, observable: self)
		)
	}
}
