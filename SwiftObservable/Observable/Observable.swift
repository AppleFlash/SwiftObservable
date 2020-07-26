//
//  Observable.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Abstract type-erasure for ObservableType
public class Observable<Element>: ObservableType {
	public func asObservable() -> Observable<Element> {
		return self
	}

	init() {}

    public func subscribe<Observer: ObserverType>(
		_ observer: Observer
	) -> Disposable where Observer.Value == Element {
        assertionFailure("Abstract method. Access only through child object")
		return Disposable {}
    }
}
