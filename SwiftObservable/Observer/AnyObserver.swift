//
//  AnyObserver.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Type-erasure for ObserverType
public final class AnyObserver<Value>: ObserverType {
	private let processClosure: (Value) -> Void

	init<O: ObserverType>(_ observer: O) where O.Value == Value {
		self.processClosure = observer.process
	}

	public func process(_ value: Value) {
		processClosure(value)
	}
}
