//
//  TestPaymentChannelCreate.swift
//
//
//  Created by Denis Angell on 8/12/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/paymentChannelCreate.test.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestPaymentChannelCreate: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "PaymentChannelCreate",
            "Amount": "10000",
            "Destination": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
            "SettleDelay": 86400,
            "PublicKey": "32D2471DB72B27E3310F355BB33E339BF26F8392D5A93D3BC0FC3B566612DA0F0A",
            "CancelAfter": 533171558,
            "DestinationTag": 23480,
            "SourceTag": 11747
        ] as! [String: AnyObject]
    }

    func testA() {
        TestPaymentChannelCreate.setUp()
        let tx = try! PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx)
        do {
            try validatePaymentChannelCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["CancelAfter"] = nil
        TestPaymentChannelCreate.baseTx["DestinationTag"] = nil
        TestPaymentChannelCreate.baseTx["SourceTag"] = nil
        let tx = try! PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx)
        do {
            try validatePaymentChannelCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["Amount"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidAmountType() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidDestinationNil() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["Destination"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidDestinationType() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["Destination"] = 10 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidSettleDelayNil() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["SettleDelay"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidSettleDelayType() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["SettleDelay"] = "10" as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidPublicKeyNil() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["PublicKey"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }

    func testInvalidPublicKeyType() {
        TestPaymentChannelCreate.setUp()
        TestPaymentChannelCreate.baseTx["PublicKey"] = 10 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestPaymentChannelCreate.baseTx))
    }
}
