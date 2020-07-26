//
//  DisposeBag.swift
//  SwiftObservable
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

/// Storage of Disposable objects. Keep objects alive until they exist
public final class DisposeBag {
    private lazy var disposables: [Disposable] = []

    func add(disposable: Disposable) {
        disposables.append(disposable)
    }

    deinit {
        disposables.removeAll()
    }
}
