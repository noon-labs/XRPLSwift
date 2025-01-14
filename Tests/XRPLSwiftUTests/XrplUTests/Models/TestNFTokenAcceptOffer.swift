//
//  TestNFTokenAcceptOffer.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenAcceptOffer.test.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestNFTokenAcceptOffer: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "NFTokenAcceptOffer",
            "NFTokenBuyOffer": "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBuyAndSellNil() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        XCTAssertThrowsError(try validateNFTokenAcceptOffer(tx: tx.toJson()))
    }

    func testInvalidSellAndBrokerNil() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        XCTAssertThrowsError(try validateNFTokenAcceptOffer(tx: tx.toJson()))
    }

    func testInvalidBuyAndBrokerNil() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        XCTAssertThrowsError(try validateNFTokenAcceptOffer(tx: tx.toJson()))
    }

    func testValidBuyAndSellOfferNoBroker() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testValidBuyAndSellOffer() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "1" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBrokerZero() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "0" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        XCTAssertThrowsError(try validateNFTokenAcceptOffer(tx: tx.toJson()))
    }

    func testInvalidBrokerLessZero() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "-1" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        XCTAssertThrowsError(try validateNFTokenAcceptOffer(tx: tx.toJson()))
    }

    func testInvalidBrokerType() {
        TestNFTokenAcceptOffer.setUp()
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = 1 as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
}
