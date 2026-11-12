//
//  Blob.swift
//
//
//  Created by Denis Angell on 7/3/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/blob.py

import Foundation

/**
 Codec for serializing and deserializing blob fields.
 See `Blob Fields <https://xrpl.org/serialization.html#blob-fields>`_
 */
/// Converts a hex string to bytes, throwing on anything that is not hex.
/// `String.hexToBytes` silently drops characters it cannot parse ("12zz34" becomes 0x12 0x34), which would make us
/// sign something other than what the caller asked for.
internal func strictHexToBytes(_ value: String) throws -> [UInt8] {
    let isHex = value.utf8.allSatisfy { byte in
        (48...57).contains(byte) || (65...70).contains(byte) || (97...102).contains(byte)
    }
    guard isHex && value.utf8.count.isMultiple(of: 2) else {
        throw BinaryError.unknownError(error: "not a valid hex string")
    }
    return value.hexToBytes
}

class Blob: SerializedType {
    // Construct a new Blob type from a ``bytes`` value.
    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? [])
    }

    /**
     Construct a new Blob type from a BinaryParser.
     - parameters:
     - parser: The parser to construct a Blob from.
     - returns:
     A new Blob.
     */
    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) throws -> Blob {
        return Blob(try parser.read(hint ?? 0))
    }

    /**
     Construct a new Blob type from a number.
     - parameters:
     - value: The value to construct a Blob from.
     - returns:
     A new Blob.
     - throws: RPLBinaryCodecException: If a Blob cannot be constructed.
     */
    static func from(_ value: String) throws -> Blob {
        return Blob(try strictHexToBytes(value))
    }
}
