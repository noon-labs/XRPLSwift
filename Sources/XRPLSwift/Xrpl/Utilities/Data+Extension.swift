//
//  Data+Extension.swift
//
//
//  Created by Denis Angell on 11/21/20.
//

import Foundation

public extension Data {
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }

    func toArray<T>(type: T.Type) throws -> [T] {
        return try self.withUnsafeBytes { (body: UnsafeRawBufferPointer) in
            if let bodyAddress = body.baseAddress, !body.isEmpty {
                let pointer = bodyAddress.assumingMemoryBound(to: T.self)
                return [T](UnsafeBufferPointer(start: pointer, count: self.count / MemoryLayout<T>.stride))
            } else {
                throw XrplError("DADA ERROR")
            }
        }
    }

    func constantTimeComparisonTo(_ other: Data?) -> Bool {
        guard let rhs = other else { return false }
        guard self.count == rhs.count else { return false }
        var difference = UInt8(0x00)
        // swiftlint:disable:next identifier_name
        for i in 0..<self.count { // compare full length
            difference |= self[i] ^ rhs[i] // constant time
        }
        return difference == UInt8(0x00)
    }

    static func zero(_ data: inout Data) {
        let count = data.count
        data.withUnsafeMutableBytes { (body: UnsafeMutableRawBufferPointer) in
            body.baseAddress?.assumingMemoryBound(to: UInt8.self).initialize(repeating: 0, count: count)
        }
    }

    static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = [UInt8](hex: string)
        if array.isEmpty {
            if hex == "0x" || hex == "" {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }

    func bitsInRange(_ startingBit: Int, _ length: Int) -> UInt64? { // return max of 8 bytes for simplicity, non-public
        if startingBit + length / 8 > self.count, length > 64, startingBit > 0, length >= 1 { return nil }
        let bytes = self[(startingBit / 8) ..< (startingBit + length + 7) / 8]
        let padding = Data(repeating: 0, count: 8 - bytes.count)
        let padded = bytes + padding
        guard padded.count == 8 else { return nil }
        let pointee = padded.withUnsafeBytes { (body: UnsafeRawBufferPointer) in
            body.baseAddress?.assumingMemoryBound(to: UInt64.self).pointee
        }
        guard let ptee = pointee else { return nil }
        var uintRepresentation = UInt64(bigEndian: ptee)
        uintRepresentation = uintRepresentation << (startingBit % 8)
        uintRepresentation = uintRepresentation >> UInt64(64 - length)
        return uintRepresentation
    }
}
