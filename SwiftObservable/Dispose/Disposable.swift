//
//  Disposable.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// The object handles Observer deinit events
/// # Reference
///  Observable.swift
public final class Disposable {
    private var dispose: () -> Void

    init(dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

	/// Includes current Disposable to DisposeBag. All objects inside bag will be released when observer will be deinited
	/// - Parameter bag: storage for current Disposable
    public func disposed(by bag: DisposeBag) {
        bag.add(disposable: self)
    }

    deinit {
        dispose()
    }
}
