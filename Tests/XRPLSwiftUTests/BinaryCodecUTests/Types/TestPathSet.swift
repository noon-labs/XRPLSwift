//
//  TestPathSet.swift
//
//
//  Created by Denis Angell on 7/16/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_path_set.py

import XCTest
@testable import XRPLSwift

let buffer: Data = Data(hex: "31585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C10000000000000000000000004254430000000000585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C131E4FE687C90257D3D2D694C8531CDEECBE84F33670000000000000000000000004254430000000000E4FE687C90257D3D2D694C8531CDEECBE84F3367310A20B3C85F482532A9578DBB3950B85CA06594D100000000000000000000000042544300000000000A20B3C85F482532A9578DBB3950B85CA06594D13000000000000000000000000055534400000000000A20B3C85F482532A9578DBB3950B85CA06594D1FF31585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C10000000000000000000000004254430000000000585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C131E4FE687C90257D3D2D694C8531CDEECBE84F33670000000000000000000000004254430000000000E4FE687C90257D3D2D694C8531CDEECBE84F33673115036E2D3F5437A83E5AC3CAEE34FF2C21DEB618000000000000000000000000425443000000000015036E2D3F5437A83E5AC3CAEE34FF2C21DEB6183000000000000000000000000055534400000000000A20B3C85F482532A9578DBB3950B85CA06594D1FF31585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C10000000000000000000000004254430000000000585E1F3BD02A15D6185F8BB9B57CC60DEDDB37C13157180C769B66D942EE69E6DCC940CA48D82337AD000000000000000000000000425443000000000057180C769B66D942EE69E6DCC940CA48D82337AD1000000000000000000000000000000000000000003000000000000000000000000055534400000000000A20B3C85F482532A9578DBB3950B85CA06594D100"
)

let expectedJson: [[[String: AnyObject]]] = [
    [
        [
            "account": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K",
            "currency": "BTC",
            "issuer": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K"
        ],
        [
            "account": "rM1oqKtfh1zgjdAgbFmaRm3btfGBX25xVo",
            "currency": "BTC",
            "issuer": "rM1oqKtfh1zgjdAgbFmaRm3btfGBX25xVo"
        ],
        [
            "account": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B",
            "currency": "BTC",
            "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
        ],
        [
            "currency": "USD",
            "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
        ]
    ],
    [
        [
            "account": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K",
            "currency": "BTC",
            "issuer": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K"
        ],
        [
            "account": "rM1oqKtfh1zgjdAgbFmaRm3btfGBX25xVo",
            "currency": "BTC",
            "issuer": "rM1oqKtfh1zgjdAgbFmaRm3btfGBX25xVo"
        ],
        [
            "account": "rpvfJ4mR6QQAeogpXEKnuyGBx8mYCSnYZi",
            "currency": "BTC",
            "issuer": "rpvfJ4mR6QQAeogpXEKnuyGBx8mYCSnYZi"
        ],
        [
            "currency": "USD",
            "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
        ]
    ],
    [
        [
            "account": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K",
            "currency": "BTC",
            "issuer": "r9hEDb4xBGRfBCcX3E4FirDWQBAYtpxC8K"
        ],
        [
            "account": "r3AWbdp2jQLXLywJypdoNwVSvr81xs3uhn",
            "currency": "BTC",
            "issuer": "r3AWbdp2jQLXLywJypdoNwVSvr81xs3uhn"
        ],
        ["currency": "XRP"],
        [
            "currency": "USD",
            "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
        ]
    ]
] as [[[String: AnyObject]]]

final class TestPathSet: XCTestCase {
    func testFromValue() {
        let pathset = try! xPathSet.from(value: expectedJson)
        XCTAssertEqual(buffer.bytes, pathset.bytes)
    }

    func testFromValueToJson() {
        let pathset = try! xPathSet.from(value: expectedJson)
        let result: [[[String: AnyObject]]] = pathset.toJson()
        XCTAssertEqual(result.count, expectedJson.count)
    }

    func testFromParserToJson() {
        let parser = BinaryParser(hex: buffer.bytes.toHex)
        let pathset = try! xPathSet.fromParser(parser: parser)
        let result: [[[String: AnyObject]]] = pathset.toJson()
        XCTAssertEqual(result.count, expectedJson.count)
    }

    // This test is not necessary in Swift?
    //    func testRaisesInvalidValueType() {
    //        let invalidValue: Int = 1
    //        XCTAssertThrowsError(try! PathSet(bytes: []).from(value: invalidValue))
    //    }
}
