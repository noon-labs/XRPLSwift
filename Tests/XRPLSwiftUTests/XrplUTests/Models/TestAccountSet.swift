//
//  TestAccountSet.swift
//
//
//  Created by Denis Angell on 6/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/accountSet.test.ts

import XCTest
@testable import XRPLSwift

final class TestAccountSet: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "AccountSet",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "Domain": "6578616D706C652E636F6D",
            "SetFlag": 5,
            "MessageKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB"
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        do {
            try validateAccountSet(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    // TODO: You cannot currently set the Flags to anything other than the Flags allowed
    // The decoded response does not include the invalid SetFlag
    func testInvalidRange() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["SetFlag"] = 17 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testDisallowIncomingAndClawbackFlagsDecode() {
        // asf 12~15 (DisallowIncoming amendment), 16 (Clawback amendment) 가 열거형에 있어야 SetFlag/ClearFlag 를 디코딩할 수 있다.
        for (flag, expected) in [(12, AccountSetAsfFlags.asfDisallowIncomingNFTokenOffer),
                                 (13, .asfDisallowIncomingCheck),
                                 (14, .asfDisallowIncomingPayChan),
                                 (15, .asfDisallowIncomingTrustline),
                                 (16, .asfAllowTrustLineClawback)] {
            TestAccountSet.setUp()
            TestAccountSet.baseTx["SetFlag"] = flag as AnyObject
            let tx = try! AccountSet(json: TestAccountSet.baseTx)
            XCTAssertEqual(tx.setFlag, expected)
            XCTAssertEqual(try! tx.toJson()["SetFlag"] as? Int, flag)
        }
    }

    func testMessageKeyRoundTrips() {
        // MessageKey 는 hex 문자열이며, 디코딩·인코딩 양쪽에 포함되어야 제출 시 누락되지 않는다.
        TestAccountSet.setUp()
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertEqual(tx.messageKey, "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB")
        XCTAssertEqual(try! tx.toJson()["MessageKey"] as? String, "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB")
    }

    func testValidTicksizePasses() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["TickSize"] = 5 as AnyObject
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertNoThrow(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidType() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["SetFlag"] = "abc" as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidClearFlag() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["ClearFlag"] = 17 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidDomain() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578616 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidEmailHash() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578616 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidMessageKey() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578656789876543 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidTransferRate() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["TransferRate"] = "1000000001" as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidTicksize() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["TickSize"] = 20 as AnyObject
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        //        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }
}
