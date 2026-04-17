//
//  Hash192.swift
//
//
//  Created for MPT (XLS-33) support.
//

// https://github.com/XRPLF/xrpl-py/blob/main/xrpl/core/binarycodec/types/hash192.py

import Foundation

class Hash192: Hash {
    /*
     Codec for serializing and deserializing a hash field with a width
     of 192 bits (24 bytes). Used for MPTokenIssuanceID.
     `See Hash Fields <https://xrpl.org/serialization.html#hash-fields>`_
     */

    internal static var WIDTH192: Int = 24
    internal static var ZERO192 = Hash192([UInt8].init(repeating: 0x0, count: Hash192.WIDTH192))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash192.ZERO192.bytes)
    }

    override class func getLength() -> Int {
        return Hash192.WIDTH192
    }
}
