//
//  TestInt.swift
//
//
//  Created by Denis Angell on 7/11/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_uint.py

import XCTest
@testable import XRPLSwift

final class TestUInt: XCTestCase {

    func testFromValue() {
        let value1 = xUInt8.from(124)
        let value2 = xUInt8.from(123)
        let value3 = xUInt8.from(124)

        XCTAssertGreaterThan(value1, value2)
        XCTAssertLessThan(value2, value1)
        XCTAssertNotEqual(value1, value2)
        XCTAssertEqual(value1, value3)
    }

    func testFromValue64() {
        let value1 = try! xUInt64.from("1000000")
        XCTAssertEqual(value1.bytes.toHexString(), "1000000000000000")
    }

    // TODO: Review these: // 8/16/32 all need .bigEndian
    func testCompare() {
        let value1: xUInt8 = xUInt8.from(124)
        XCTAssertEqual(value1.value, 124)
        XCTAssertLessThan(value1.value, 125)
        XCTAssertGreaterThan(value1.value, 123)
    }

    func testCompareDifferent() {
        let const: Int = 124
        let string: String = "000000000000007C"
        let uint8: xUInt8 = xUInt8.from(const)
        let uint16: xUInt16 = xUInt16.from(const)
        let uint32: xUInt32 = xUInt32.from(const)
        let uint64: xUInt64 = try! xUInt64.from(const)
        let uint64s: xUInt64 = try! xUInt64.from(string)

        XCTAssertEqual(Int(uint8.str()), Int(uint16.str()))
        XCTAssertEqual(Int(uint16.str()), Int(uint32.str()))
        XCTAssertEqual(Int(uint32.str()), Int(uint64.str()))
        XCTAssertEqual(uint64.value, const)
        XCTAssertEqual(uint64s.str(), string)
    }

    // MARK: INVALID SWIFT IMPLEMENTATION
    //    func test_raises_invalid_value_type() {
    //        let invalidValue: [UInt8] = [1, 2, 3]
    //        XCTAssertThrowsError(try xUInt8().from(value: invalidValue))
    //        XCTAssertThrowsError(try xUInt16().from(value: invalidValue))
    //        XCTAssertThrowsError(try xUInt32().from(value: invalidValue))
    //        XCTAssertThrowsError(try xUInt64().from(value: invalidValue))
    //    }
}
