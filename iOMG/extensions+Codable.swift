// Ideas learned from here: https://github.com/omgnetwork/ios-sdk/blob/416f22ce411c63b1706db654a9f3eb8bcee6936a/Source/Core/Helpers/Codable.swift

import BigInt
import Foundation

extension KeyedDecodingContainerProtocol {
    func decode(_ type: BigUInt.Type, forKey key: Key) throws -> BigUInt {
        guard let bigUInt = try self.decodeOptional(type, forKey: key) else {
            throw NSError(domain: "Invalid", code: 42, userInfo: nil)
        }
        return bigUInt
    }

    func decode(_ type: BigUInt.Type, forKey key: Key) throws -> BigUInt? {
        return try self.decodeOptional(type, forKey: key)
    }

    private func decodeOptional(_: BigUInt.Type, forKey key: Key) throws -> BigUInt? {
        let parsedBigUInt: BigUInt?
        // There is an issue currently in swift when initializing a Decimal number with an Int64 type.
        // https://bugs.swift.org/browse/SR-7054
        // This is a workaround where we first try to decode the number as a UInt and fallback to Decimal if it fails.
        do {
            parsedBigUInt = BigUInt(String((try self.decode(UInt.self, forKey: key))))
        } catch _ {
            do {
                parsedBigUInt = BigUInt((try self.decode(Decimal.self, forKey: key)).description)
            } catch _ {
                return nil
            }
        }
        guard let amount = parsedBigUInt, amount.description.count <= 38 else {
            throw NSError(domain: "Invalid", code: 42, userInfo: nil)
        }
        return amount
    }
}
