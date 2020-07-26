//
//  ObservableType+Extension.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

public extension ObservableType {
	/// Allows to subscribe for changes with particular action
	/// - Parameter action: action, that will be triggered when observable object would changed
	/// - Returns: disposable object that will be released in the same time with observer
	func subscribe(_ action: @escaping (Element) -> Void) -> Disposable {
		let observer = AnonymousObserver(action)
		return subscribe(observer)
	}
}
