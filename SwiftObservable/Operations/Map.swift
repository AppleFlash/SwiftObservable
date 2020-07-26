//
//  Map.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

extension ObservableType {
	func map<ResultType>(_ transform: @escaping (Element) -> ResultType) -> Observable<ResultType> {
		return MapObservable(source: asObservable(), transform: transform)
	}
}

private final class MapObservable<OldType, ResultType>: Observable<ResultType> {
	private final class MapTransformer<Observer: ObserverType>: ObserverType {
		private let observer: Observer
		private var observable: MapObservable<OldType, Observer.Value>

		init(observer: Observer, observable: MapObservable<OldType, Observer.Value>) {
			self.observer = observer
			self.observable = observable
		}

		func process(_ value: OldType) {
			let newValue = observable.transform(value)
			observer.process(newValue)
		}
	}

	fileprivate let transform: (OldType) -> ResultType
	private let source: Observable<OldType>

	init(source: Observable<OldType>, transform: @escaping (OldType) -> ResultType) {
		self.source = source
		self.transform = transform
	}

	override func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Element == Observer.Value {
		return source.subscribe(
			MapTransformer(observer: observer, observable: self)
		)
	}
}
