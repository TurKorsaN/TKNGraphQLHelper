//
//  TKNAnyCodable.swift
//  TKNGraphQLHelper
//
//  Created by Alper Sevindik on 25.11.2019.
//  Copyright © 2019 Alper Sevindik. All rights reserved.
//

public struct TKNAnyCodable: Codable {
    public let value: Any

    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

extension TKNAnyCodable: _TKNAnyEncodable, _TKNAnyDecodable {}

extension TKNAnyCodable: Equatable {
    public static func == (lhs: TKNAnyCodable, rhs: TKNAnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: TKNAnyCodable], rhs as [String: TKNAnyCodable]):
            return lhs == rhs
        case let (lhs as [TKNAnyCodable], rhs as [TKNAnyCodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension TKNAnyCodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension TKNAnyCodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyCodable(\(value.debugDescription))"
        default:
            return "AnyCodable(\(description))"
        }
    }
}

extension TKNAnyCodable: ExpressibleByNilLiteral {}
extension TKNAnyCodable: ExpressibleByBooleanLiteral {}
extension TKNAnyCodable: ExpressibleByIntegerLiteral {}
extension TKNAnyCodable: ExpressibleByFloatLiteral {}
extension TKNAnyCodable: ExpressibleByStringLiteral {}
extension TKNAnyCodable: ExpressibleByArrayLiteral {}
extension TKNAnyCodable: ExpressibleByDictionaryLiteral {}

