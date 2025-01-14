//
//  AccountID.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/account_id.py

import Foundation

// swiftlint:disable:next identifier_name
internal let HEX_REGEX: String = #"^[A-F0-9]{40}$"#
internal let LENGTH20: Int = 20

class AccountID: Hash160 {
    static let LENGTH: Int = 20
    static var defaultAccountID = AccountID([UInt8].init(repeating: 0x0, count: 20))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? AccountID.defaultAccountID.bytes)
    }

    static func from(_ value: AccountID) throws -> AccountID {
        return value
    }

    override static func from(_ value: String) throws -> AccountID {
        if value.isEmpty {
            return AccountID(nil)
        }

        return (value.range(
            of: HEX_REGEX,
            options: .regularExpression
        ) != nil) ? AccountID(value.hexToBytes) : try AccountID.fromBase58(value)
    }

    static func fromBase58(_ value: String) throws -> AccountID {
        if AddressCodec.isValidXAddress(value) {
            let fullClassic: FullClassicAddress = try AddressCodec.xAddressToClassicAddress(value)
            let classic: String = fullClassic.classicAddress
            let tag = Int(fullClassic.tag ?? 0)
            if tag != 0 {
                throw BinaryError.unknownError(error: "Only allowed to have tag on Account or Destination")
            }
            return AccountID(try XrplCodec.decodeClassicAddress(classic))
        } else {
            return AccountID(try XrplCodec.decodeClassicAddress(value))
        }
    }

    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) -> AccountID {
        return AccountID(try! parser.read(hint ?? LENGTH20))
    }

    override func toJson() -> Any {
        return try! XrplCodec.encodeClassicAddress(self.bytes)
    }
}
