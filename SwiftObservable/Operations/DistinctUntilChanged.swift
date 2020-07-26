//
//  DistinctUntilChanged.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

public extension ObservableType where Element: Equatable {
	func distinctUntilChanged() -> Observable<Element> {
		return DistinctObservable(source: self.asObservable())
	}
}

private final class DistinctObservable<Element>: Observable<Element> where Element: Equatable {
	private final class DistinctTransformer<Observer: ObserverType>: ObserverType where Observer.Value: Equatable {
		private let observer: Observer

		private var oldValue: Observer.Value?

		init(observer: Observer) {
			self.observer = observer
		}

		func process(_ value: Observer.Value) {
			guard value != oldValue else { return }

			oldValue = value

			observer.process(value)
		}
	}

	private let source: Observable<Element>

	init(source: Observable<Element>) {
		self.source = source
	}

	override func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Observer.Value == Element {
		let transformer = DistinctTransformer(observer: observer)
		return source.subscribe(transformer)
	}
}
