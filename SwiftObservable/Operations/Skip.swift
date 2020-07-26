//
//  Skip.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

extension ObservableType {
	func skip(_ count: Int) -> Observable<Element> {
		return SkipObservable(source: asObservable(), skipCoint: count)
	}
}

private final class SkipObservable<Element>: Observable<Element> {
	private final class SkipTransformer<Observer: ObserverType>: ObserverType {
		private let observer: Observer
		private var remaining: Int

		init(observer: Observer, skip: Int) {
			self.observer = observer
			self.remaining = skip
		}

		func process(_ value: Observer.Value) {
			if remaining <= 0 {
				observer.process(value)
			} else {
				remaining -= 1
			}
		}
	}

	private let skipCoint: Int
	private let source: Observable<Element>

	init(source: Observable<Element>, skipCoint: Int) {
		self.source = source
		self.skipCoint = skipCoint
	}

	override func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Element == Observer.Value {
		return source.subscribe(
			SkipTransformer(observer: observer, skip: skipCoint)
		)
	}
}
