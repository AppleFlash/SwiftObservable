//
//  ObserverType.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Active object that listens the Observable and do actions when Observable is changed
public protocol ObserverType: class {
	associatedtype Value

	/// Method is triggered when observable value of Observable is changed
	/// - Parameter value: new observable value
	func process(_ value: Value)
}
