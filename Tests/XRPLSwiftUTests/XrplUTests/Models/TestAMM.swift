//
//  TestAMM.swift
//
//
//  Created for AMM (XLS-30) support.
//

// 기준 blob 은 ripple-binary-codec 1.11.0 의 encode() 결과 (AMMClawback 은 정의를 주입해 생성).

import XCTest
@testable import XRPLSwift

final class TestAMM: XCTestCase {

    private func canonical(_ any: Any) -> String {
        let data = try! JSONSerialization.data(withJSONObject: any, options: [.sortedKeys])
        return String(data: data, encoding: .utf8)!
    }

    func testAMMCreateEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMCreate",
            "Amount": "1000000",
            "Amount2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
                "value": "50"
            ],
            "TradingFee": 500
        ]
        let blob = "1200231501F424000000056140000000000F424068400000000000000C6BD4D1C37937E080000000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA9"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMDepositEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMDeposit",
            "Flags": 1048576,
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "Amount": "1000000",
            "Amount2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
                "value": "50"
            ]
        ]
        let blob = "120024220010000024000000056140000000000F424068400000000000000C6BD4D1C37937E080000000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA90318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMDepositLPEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMDeposit",
            "Flags": 65536,
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "LPTokenOut": [
                "currency": "03930D02208264E2E40EC1B0C09E4DB96EE197B1",
                "issuer": "rE54zDvgnghAoPopCgvtiqWNq3dU5y836S",
                "value": "100"
            ]
        ]
        let blob = "1200242200010000240000000568400000000000000C6019D5038D7EA4C6800003930D02208264E2E40EC1B0C09E4DB96EE197B1A1652B3CCB5BDF6DEBF2DD197BF844CCF4C4064E732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA90318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMWithdrawLPEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMWithdraw",
            "Flags": 65536,
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "LPTokenIn": [
                "currency": "03930D02208264E2E40EC1B0C09E4DB96EE197B1",
                "issuer": "rE54zDvgnghAoPopCgvtiqWNq3dU5y836S",
                "value": "100"
            ]
        ]
        let blob = "1200252200010000240000000568400000000000000C601AD5038D7EA4C6800003930D02208264E2E40EC1B0C09E4DB96EE197B1A1652B3CCB5BDF6DEBF2DD197BF844CCF4C4064E732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA90318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMVoteEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMVote",
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "TradingFee": 250
        ]
        let blob = "1200261500FA240000000568400000000000000C732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA90318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMBidEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMBid",
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "BidMin": [
                "currency": "03930D02208264E2E40EC1B0C09E4DB96EE197B1",
                "issuer": "rE54zDvgnghAoPopCgvtiqWNq3dU5y836S",
                "value": "100"
            ],
            "BidMax": [
                "currency": "03930D02208264E2E40EC1B0C09E4DB96EE197B1",
                "issuer": "rE54zDvgnghAoPopCgvtiqWNq3dU5y836S",
                "value": "200"
            ],
            "AuthAccounts": [[
                "AuthAccount": [
                    "Account": "rN7n7otQDd6FczFgLdSqtcsAUxDkw6fzRH"
                ]
            ]]
        ]
        let blob = "120027240000000568400000000000000C6CD5038D7EA4C6800003930D02208264E2E40EC1B0C09E4DB96EE197B1A1652B3CCB5BDF6DEBF2DD197BF844CCF4C4064E6DD5071AFD498D000003930D02208264E2E40EC1B0C09E4DB96EE197B1A1652B3CCB5BDF6DEBF2DD197BF844CCF4C4064E732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA9F019E01B811493B89AFCAD4C8EAC2B131C1331FEF12AE1522BBEE1F10318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMDeleteEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "TransactionType": "AMMDelete",
            "Asset": [
                "currency": "XRP"
            ],
            "Asset2": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ]
        ]
        let blob = "120028240000000568400000000000000C732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB81144B4E9C06F24296074F7BC48F92A97916C6DC5EA90318000000000000000000000000000000000000000004180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA8"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testAMMClawbackEncodesLikeXrplJs() throws {
        let tx: [String: Any] = [
            "TransactionType": "AMMClawback",
            "Account": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
            "Fee": "12",
            "Sequence": 5,
            "Flags": 1,
            "SigningPubKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB",
            "Holder": "rN7n7otQDd6FczFgLdSqtcsAUxDkw6fzRH",
            "Asset": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
            ],
            "Asset2": [
                "currency": "XRP"
            ],
            "Amount": [
                "currency": "USD",
                "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
                "value": "10"
            ]
        ]
        let blob = "12001F2200000001240000000561D4C38D7EA4C680000000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA868400000000000000C732103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB8114F667B0CA50CC7709A220B0561B85E53A48461FA88B1493B89AFCAD4C8EAC2B131C1331FEF12AE1522BBE03180000000000000000000000005553440000000000F667B0CA50CC7709A220B0561B85E53A48461FA804180000000000000000000000000000000000000000"
        XCTAssertEqual(try BinaryCodec.encode(tx).uppercased(), blob)
        let decoded = BinaryCodec.decode(blob)
        XCTAssertEqual(canonical(decoded), canonical(tx))
        XCTAssertNoThrow(try validate(transaction: tx as [String: AnyObject]))
        XCTAssertNotNil(try Transaction(tx as [String: AnyObject]))
    }

    func testIssueCodecRejectsXrpWithIssuer() {
        let tx: [String: Any] = ["TransactionType": "AMMDelete", "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
                                 "Asset": ["currency": "XRP", "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"],
                                 "Asset2": ["currency": "USD", "issuer": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"]]
        XCTAssertThrowsError(try BinaryCodec.encode(tx))
    }

    func testValidationRules() {
        let acct = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn", issuer = "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe"
        let usd: [String: Any] = ["currency": "USD", "issuer": issuer]
        let rejected: [[String: Any]] = [
            ["TransactionType": "AMMCreate", "Account": acct, "Amount": "1", "Amount2": ["currency": "USD", "issuer": issuer, "value": "1"], "TradingFee": 1001],
            ["TransactionType": "AMMDeposit", "Account": acct, "Asset": ["currency": "XRP"], "Asset2": usd],
            ["TransactionType": "AMMWithdraw", "Account": acct, "Asset": ["currency": "XRP"], "Asset2": usd, "EPrice": "5"],
            ["TransactionType": "AMMBid", "Account": acct, "Asset": ["currency": "XRP"], "Asset2": usd, "AuthAccounts": [["AuthAccount": ["Account": acct]]]],
            ["TransactionType": "AMMClawback", "Account": acct, "Holder": acct, "Asset": usd, "Asset2": ["currency": "XRP"]],
        ]
        for tx in rejected {
            XCTAssertThrowsError(try validate(transaction: tx as [String: AnyObject]), "\(tx["TransactionType"]!) 는 거부되어야 한다")
        }
    }
}
