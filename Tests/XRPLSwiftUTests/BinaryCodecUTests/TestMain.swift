//
//  TestBinaryCodec.swift
//
//
//  Created by Denis Angell on 7/24/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/test_main.py

import XCTest
@testable import XRPLSwift

let TX_JSON: [String: AnyObject] = [
    "Account": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
    "Destination": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
    "Flags": (1 << 31),  // tfFullyCanonicalSig
    "Sequence": 1,
    "TransactionType": "Payment"
] as [String: AnyObject]

let jsonX1: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "XVXdn5wEVm5G4UhEHWDPqjvdeH361P7BsapL4m2D2XnPSwT",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000"
] as [String: AnyObject]

let jsonR1: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000",
    "SourceTag": 12345
] as [String: AnyObject]

let jsonNullX: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Destination": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Issuer": "XVXdn5wEVm5G4UhEHWDPqjvdeH361P4GETfNyyXGaoqBj71",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000"
] as [String: AnyObject]

let jsonInvalidX: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Destination": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Issuer": "XVXdn5wEVm5g4UhEHWDPqjvdeH361P4GETfNyyXGaoqBj71",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000"
] as [String: AnyObject]

let jsonNullR: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Destination": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Issuer": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000"
] as [String: AnyObject]

let invalidJsonIssuerTagged: [String: AnyObject] = [
    "OwnerCount": 0,
    "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Destination": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
    "Issuer": "XVXdn5wEVm5G4UhEHWDPqjvdeH361P7BsapL4m2D2XnPSwT",
    "PreviousTxnLgrSeq": 7,
    "LedgerEntryType": "AccountRoot",
    "PreviousTxnID": "DF530FB14C5304852F20080B0A8EEF3A6BDD044F41F4EBBD68B8B321145FE4FF",
    "Flags": 0,
    "Sequence": 1,
    "Balance": "10000000000"
] as [String: AnyObject]

var validJsonXAndTags: [String: AnyObject] = [
    "TransactionType": "Payment",
    "Account": "XVXdn5wEVm5G4UhEHWDPqjvdeH361P7BsapL4m2D2XnPSwT",  // Tag: 12345
    "SourceTag": 12345,
    "Destination": "X7c6XhVKioTMkCS8eEc3PsAoeHTdFjEa1sRcUiULHd265yt",  // Tag: 13
    "DestinationTag": 13,
    "Flags": 0,
    "Sequence": 1,
    "Amount": "1000000"
] as [String: AnyObject]

let signingJson: [String: AnyObject] = [
    "Account": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
    "Amount": "1000",
    "Destination": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
    "Fee": "10",
    "Flags": 2147483648,
    "Sequence": 1,
    "TransactionType": "Payment",
    "TxnSignature": (
        "30440220718D264EF05CAED7C781FF6DE298DCAC68D002562C9BF3A07C1E721B420C0DAB02203A5A4779EF4D2CCC7BC3EF886676D803A9981B928D3B8ACA483B80ECA3CD7B9B"
    ),
    "Signature": (
        "30440220718D264EF05CAED7C781FF6DE298DCAC68D002562C9BF3A07C1E721B420C0DAB02203A5A4779EF4D2CCC7BC3EF886676D803A9981B928D3B8ACA483B80ECA3CD7B9B"
    ),
    "SigningPubKey": (
        "ED5F5AC8B98974A3CA843326D9B88CEBD0560177B973EE0B149F782CFAA06DC66A"
    )
] as [String: AnyObject]

final class TestBinarySimple: XCTestCase {

    func testSimple() {
        let encoded = try! BinaryCodec.encode(TX_JSON)
        let decoded = BinaryCodec.decode(encoded)
        XCTAssert(TX_JSON == decoded)
    }

    func testAmountFee() {
        var clone = TX_JSON
        clone["Amount"] = "1000" as AnyObject
        clone["Fee"] = "10" as AnyObject
        XCTAssert(BinaryCodec.decode(try! BinaryCodec.encode(clone)) == clone)
    }

    func testInvalidAmountFee() {
        var clone = TX_JSON
        clone["Amount"] = "1000.789" as AnyObject
        clone["Fee"] = "10.123" as AnyObject
        XCTAssertThrowsError(try BinaryCodec.encode(clone))
    }

    func testInvalidAmountInvalidFee() {
        var clone = TX_JSON
        clone["Amount"] = "1000.001" as AnyObject
        clone["Fee"] = "10" as AnyObject
        XCTAssertThrowsError(try BinaryCodec.encode(clone))
    }

    func testInvalidAmountType() {
        var clone = TX_JSON
        clone["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try BinaryCodec.encode(clone))
    }

    func testInvalidFeeType() {
        var clone = TX_JSON
        clone["Amount"] = "1000.789" as AnyObject
        clone["Fee"] = 10 as AnyObject
        XCTAssertThrowsError(try BinaryCodec.encode(clone))
    }
}

final class TestBinaryXAddress: XCTestCase {

    func testXaddressEncode() {
        XCTAssertEqual(try BinaryCodec.encode(jsonX1), try BinaryCodec.encode(jsonR1))
    }

    // TODO: Compare Any
    //    func testXaddressDecode() {
    //        XCTAssertEqual(BinaryCodec.decode(buffer: BinaryCodec.encode(json: jsonX1)), jsonR1)
    //    }

    func testXaddressNullTag() {
        XCTAssertEqual(try BinaryCodec.encode(jsonNullX), try BinaryCodec.encode(jsonNullR))
    }

    func testXaddressInvalid() {
        XCTAssertThrowsError(try BinaryCodec.encode(jsonInvalidX))
    }

    func testXaddressInvalidField() {
        XCTAssertThrowsError(try BinaryCodec.encode(invalidJsonIssuerTagged))
    }

    func testXaddressXaddrAndMismatchedSourceTag() {
        var invalidJsonXAndSourceTag: [String: Any] = validJsonXAndTags
        invalidJsonXAndSourceTag.merge(["SourceTag": 999]) { (_, new) in new }
        XCTAssertThrowsError(try BinaryCodec.encode(invalidJsonXAndSourceTag))
    }

    func testXaddressXaddrAndMismatchedDestTag() {
        var invalidJsonXAndDestTag: [String: Any] = validJsonXAndTags
        invalidJsonXAndDestTag.merge(["DestinationTag": 999]) { (_, new) in new }
        XCTAssertThrowsError(try BinaryCodec.encode(invalidJsonXAndDestTag))
    }

    func testxaddressXaddrAndMatchingSourceTag() {
        var validJsonNoXTags: [String: Any] = validJsonXAndTags
        validJsonNoXTags.merge([
            "Account": "rLs1MzkFWCxTbuAHgjeTZK4fcCDDnf2KRv",
            "Destination": "rso13LJmsQvPzzV3q1keJjn6dLRFJm95F2"
        ]) { (_, new) in new }
        XCTAssertEqual(try BinaryCodec.encode(validJsonXAndTags), try BinaryCodec.encode(validJsonNoXTags))
    }
}

final class TestMainFixtures: XCTestCase {
    let maxDiff: Int = 1000

    var CODEC_FIXTURES_JSON: [String: AnyObject] = [:]
    var XCODEC_FIXTURES_JSON: [String: AnyObject] = [:]

    override func setUp() async throws {
        do {
            let data: Data = codecFixturesJson.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: AnyObject] {
                self.CODEC_FIXTURES_JSON = jsonResult
                XCTAssertNotEqual(self.CODEC_FIXTURES_JSON.count, 0)
            }
            let xdata: Data = xcodecFixturesJson.data(using: .utf8)!
            let xjsonResult = try JSONSerialization.jsonObject(with: xdata, options: .mutableLeaves)
            if let xjsonResult = xjsonResult as? [String: AnyObject] {
                self.XCODEC_FIXTURES_JSON = xjsonResult
                XCTAssertNotEqual(self.XCODEC_FIXTURES_JSON.count, 0)
            }
        } catch {
            print(error.localizedDescription)
            XCTAssertEqual(error.localizedDescription, nil)
        }
    }

    func checkBinaryAndJson(test: [String: AnyObject]) {
        let testBinary: String = test["binary"] as! String
        let testJson: [String: AnyObject] = test["json"] as! [String: AnyObject]
        XCTAssertEqual(try BinaryCodec.encode(testJson), testBinary)
        //        XCTAssertTrue(BinaryCodec.decode(buffer: testBinary) == testJson)
    }

    func checkXaddressJsons(test: [String: AnyObject]) {
        let xJson: [String: AnyObject] = test["xjson"] as! [String: AnyObject]
        let rJson: [String: AnyObject] = test["rjson"] as! [String: AnyObject]
        XCTAssertEqual(try BinaryCodec.encode(xJson), try BinaryCodec.encode(rJson))
        XCTAssertTrue(BinaryCodec.decode(try BinaryCodec.encode(xJson)) == rJson)
    }

    func runFixturesTest(filename: String, category: String, testMethod: Any) {
        var fixturesJson: [String: AnyObject] = [:]
        switch filename {
        case "codec-fixtures.json":
            fixturesJson = self.CODEC_FIXTURES_JSON
            let tests = fixturesJson[category] as! [[String: AnyObject]]
            for test in tests {
                switch category {
                case "accountState":
                    self.checkBinaryAndJson(test: test)
                case "transactions":
                    self.checkBinaryAndJson(test: test)
                default:
                    return
                }
            }
        case "x-codec-fixtures.json":
            fixturesJson = self.XCODEC_FIXTURES_JSON
            let tests = fixturesJson[category] as! [[String: AnyObject]]
            for test in tests {
                switch category {
                case "transactions":
                    self.checkXaddressJsons(test: test)
                default:
                    return
                }
            }
        default:
            print("ERROR BINARY CODEC MAIN TEST")
            return
        }
    }

    func testCodecFixturesAccountState() {
        self.runFixturesTest(
            filename: "codec-fixtures.json",
            category: "accountState",
            testMethod: self.checkBinaryAndJson
        )
    }

    func testCodecFixturesTransaction() {
        self.runFixturesTest(
            filename: "codec-fixtures.json",
            category: "transactions",
            testMethod: self.checkBinaryAndJson
        )
    }

    func testXCodecFixtures() {
        self.runFixturesTest(
            filename: "x-codec-fixtures.json",
            category: "transactions",
            testMethod: self.checkXaddressJsons
        )
    }

    func testWholeObjectFixtures() {
        let wholeObjectTests = DataDrivenFixtures().getWholeObjectTests()
        for wholeObject in wholeObjectTests {
            XCTAssertEqual(try BinaryCodec.encode(wholeObject.txJson), wholeObject.expectedHex)
            //            XCTAssertTrue(BinaryCodec.decode(buffer: wholeObject.expectedHex) == wholeObject.txJson)
        }
    }
}

final class TestMainSigning: XCTestCase {
    internal let maxDiff: Int = 1000

    func testSingleSigning() {
        let expected: String = "53545800120000228000000024000000016140000000000003E868400000000000000A7321ED5F5AC8B98974A3CA843326D9B88CEBD0560177B973EE0B149F782CFAA06DC66A81145B812C9D57731E27A2DA8B1830195F88EF32A3B68314B5F762798A53D543A014CAF8B297CFF8F2F937E8"
        XCTAssertEqual(try BinaryCodec.encodeForSigning(signingJson), expected)
    }

    func testClaim() {
        let channel: String = "43904CBFCDCEC530B4037871F86EE90BF799DF8D2E0EA564BC8A3F332E4F5FB1"
        let amount: String = "1000"
        let claim: ChannelClaim = ChannelClaim(amount: amount, channel: channel)
        let expected: String = "434C4D0043904CBFCDCEC530B4037871F86EE90BF799DF8D2E0EA564BC8A3F332E4F5FB100000000000003E8"
        XCTAssertEqual(try BinaryCodec.encodeForSigningClaim(claim), expected)
    }

    func testMultisig() {
        let signingAccount: String = "rJZdUusLDtY9NEsGea7ijqhVrXv98rYBYN"
        var multisigJson: [String: Any] = signingJson
        multisigJson.merge(["SigningPubKey": ""]) { (_, new) in new }
        let expected: String = "534D5400120000228000000024000000016140000000000003E868400000000000000A730081145B812C9D57731E27A2DA8B1830195F88EF32A3B68314B5F762798A53D543A014CAF8B297CFF8F2F937E8C0A5ABEF242802EFED4B041E8F2D4A8CC86AE3D1"
        XCTAssertEqual(
            try BinaryCodec.encodeForMultisigning(multisigJson, signingAccount),
            expected
        )
    }
}
