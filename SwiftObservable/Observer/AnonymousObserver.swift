//
//  AnonymousObserver.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

final class AnonymousObserver<Value>: ObserverType {
	private let action: (Value) -> Void

	init(_ action: @escaping (Value) -> Void) {
		self.action = action
	}

	func process(_ value: Value) {
		action(value)
	}
}
