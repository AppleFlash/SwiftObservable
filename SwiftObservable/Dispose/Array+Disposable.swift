//
//  Array+Disposable.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

public extension Array where Element: Disposable {
	/// Appends every Disposable to DisposeBag
	/// - Parameter bag: storage for every Disposable
    func disposed(by bag: DisposeBag) {
        forEach { $0.disposed(by: bag) }
    }
}
