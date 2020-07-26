//
//  SubjectTests.swift
//  SwiftObservableTests
//
//  Created by Vladislav Sedinkin on 26.07.2020.
//  Copyright © 2020 Vladislav Sedinkin. All rights reserved.
//

import XCTest
@testable import SwiftObservable

private final class InvokeData<T> {
	var count: Int = 0
	var values: [T] = []
}

final class SubjectTests: XCTestCase {
	private var disposeBag: DisposeBag!
	private var subject: Subject<Int>!
	private var observable: Observable<Int> { subject.asObservable() }

    override func setUpWithError() throws {
		disposeBag = .init()
		subject = .init(value: 0)
    }

    func testValueChanging() throws {
		XCTAssertEqual(subject.value, 0)
		subject.value = 1
		XCTAssertEqual(subject.value, 1)
    }

	func testObserving() {
		let invokeData = InvokeData<Int>()

		observable
			.subscribe { writeAction(invokeData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1

		XCTAssertEqual(invokeData.count, 2)
		XCTAssertEqual(invokeData.values, [0, 1])
	}

	func testMultipleObservers() {
		let firstData = InvokeData<Int>()
		let secondData = InvokeData<Int>()

		observable
			.subscribe { writeAction(firstData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1

		observable
			.subscribe { writeAction(secondData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 2

		XCTAssertEqual(firstData.count, 3)
		XCTAssertEqual(firstData.values, [0, 1, 2])
		XCTAssertEqual(secondData.count, 2)
		XCTAssertEqual(secondData.values, [1, 2])
	}

	func testDistinctUntilChanged() {
		let firstData = InvokeData<Int>()
		let secondData = InvokeData<Int>()

		observable
			.distinctUntilChanged()
			.subscribe { writeAction(firstData, value: $0) }
			.disposed(by: disposeBag)

		observable
			.subscribe { writeAction(secondData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1
		subject.value = 1
		subject.value = 2

		XCTAssertEqual(firstData.count, 3)
		XCTAssertEqual(firstData.values, [0, 1, 2])
		XCTAssertEqual(secondData.count, 4)
		XCTAssertEqual(secondData.values, [0, 1, 1, 2])
	}

	func testFilter() {
		let invokeData = InvokeData<Int>()

		observable
			.filter { $0 > 0 }
			.subscribe { writeAction(invokeData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1

		XCTAssertEqual(invokeData.count, 1)
		XCTAssertEqual(invokeData.values, [1])
	}

	func testMap() {
		let invokeData = InvokeData<String>()

		observable
			.map { "\($0)" }
			.subscribe { writeAction(invokeData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1

		XCTAssertEqual(invokeData.count, 2)
		XCTAssertEqual(invokeData.values, ["0", "1"])
	}

	func testSkip() {
		let invokeData = InvokeData<Int>()

		observable
			.skip(2)
			.subscribe { writeAction(invokeData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1
		subject.value = 2

		XCTAssertEqual(invokeData.count, 1)
		XCTAssertEqual(invokeData.values, [2])
	}

	func testAltogether() {
		let invokeData = InvokeData<String>()

		observable
			.skip(1)
			.distinctUntilChanged()
			.filter { $0 > 2 }
			.map { "\($0)" }
			.subscribe { writeAction(invokeData, value: $0) }
			.disposed(by: disposeBag)

		subject.value = 1
		subject.value = 2
		subject.value = 3
		subject.value = 3
		subject.value = 4

		XCTAssertEqual(invokeData.count, 2)
		XCTAssertEqual(invokeData.values, ["3", "4"])
	}
}

private func writeAction<T>(_ invokeData: InvokeData<T>, value: T) {
	invokeData.count += 1
	invokeData.values.append(value)
}
