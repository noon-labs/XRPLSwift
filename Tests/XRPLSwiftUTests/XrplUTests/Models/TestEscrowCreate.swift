//
//  TestEscrowCreate.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowCreate.test.ts

import XCTest
@testable import XRPLSwift

final class TestEscrowCreate: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestEscrowCreate.baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "EscrowCreate",
            "Amount": "10000",
            "Destination": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
            "CancelAfter": 533257958,
            "FinishAfter": 533171558,
            "Condition":
                "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
            "DestinationTag": 23480,
            "SourceTag": 11747
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! EscrowCreate(json: TestEscrowCreate.baseTx)
        do {
            try validateEscrowCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Amount"] = nil
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidDestinationNil() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Destination"] = nil
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidDestinationType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Destination"] = 10 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidAmountType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidCancelAfterType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["CancelAfter"] = "1000" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidFinishAfterType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["FinishAfter"] = "1000" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidConditionType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Condition"] = 0x141243 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidDestinationTagType() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["DestinationTag"] = "100" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestEscrowCreate.baseTx))
    }

    func testInvalidCancelAndFinish() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["CancelAfter"] = nil
        TestEscrowCreate.baseTx["FinishAfter"] = nil
        let tx = try! EscrowCreate(json: TestEscrowCreate.baseTx)
        XCTAssertThrowsError(try validateEscrowCreate(tx: tx.toJson()))
    }

    func testInvalidConditionAndFinish() {
        TestEscrowCreate.setUp()
        TestEscrowCreate.baseTx["Condition"] = nil
        TestEscrowCreate.baseTx["FinishAfter"] = nil
        let tx = try! EscrowCreate(json: TestEscrowCreate.baseTx)
        XCTAssertThrowsError(try validateEscrowCreate(tx: tx.toJson()))
    }
}
