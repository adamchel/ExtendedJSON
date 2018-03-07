//
//  ExtendedJSONRepresentable.swift
//  ExtendedJSON
//

import Foundation

public protocol ExtendedJSONRepresentable: Codable {
    static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable

    var toExtendedJSON: Any { get }

    func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool
}

internal struct ExtendedJSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = ""
    }

    static let info = ExtendedJSONCodingKeys(stringValue: "__$info__")!
}

extension ExtendedJSONRepresentable {
    internal static func encodeUnkeyedContainer(sourceMap: inout [Int: String],
                                                forKey key: Int,
                                                withValue value: ExtendedJSONRepresentable) throws -> (inout UnkeyedEncodingContainer) throws -> () {
        func setSourceKey<V>(_ xKey: String,
                             andEncode value: V?) throws -> (inout UnkeyedEncodingContainer) throws -> () where V: ExtendedJSONRepresentable {
            sourceMap[key] = xKey
            if let value = value {
                return { try $0.encode(value as V) }
            } else {
                return { try $0.encodeNil() }
            }
        }

        switch value {
        case let val as ObjectId: return try setSourceKey(ExtendedJSONKeys.objectid.rawValue, andEncode: val)
        case let val as Symbol: return try setSourceKey(ExtendedJSONKeys.symbol.rawValue, andEncode: val)
        case let val as Decimal: return try setSourceKey(ExtendedJSONKeys.numberDecimal.rawValue, andEncode: val)
        case let val as Double: return try setSourceKey(ExtendedJSONKeys.numberDouble.rawValue, andEncode: val)
        case let val as Int32: return try setSourceKey(ExtendedJSONKeys.numberInt.rawValue, andEncode: val)
        case let val as Int64: return try setSourceKey(ExtendedJSONKeys.numberLong.rawValue, andEncode: val)
        case let val as Int: return try setSourceKey(ExtendedJSONKeys.numberLong.rawValue, andEncode: val)
        case let val as RegularExpression: return try setSourceKey(ExtendedJSONKeys.regex.rawValue, andEncode: val)
        case let val as UUID: return try setSourceKey(ExtendedJSONKeys.binary.rawValue, andEncode: val)
        case let val as Date: return try setSourceKey(ExtendedJSONKeys.date.rawValue, andEncode: val)
        case let val as Binary: return try setSourceKey(ExtendedJSONKeys.binary.rawValue, andEncode: val)
        case let val as DBPointer: return try setSourceKey(ExtendedJSONKeys.dbPointer.rawValue, andEncode: val)
        case let val as Timestamp: return try setSourceKey(ExtendedJSONKeys.timestamp.rawValue, andEncode: val)
        case let val as DBRef: return try setSourceKey(ExtendedJSONKeys.dbRef.rawValue, andEncode: val)
        case let val as Undefined: return try setSourceKey(ExtendedJSONKeys.undefined.rawValue, andEncode: val)
        case let val as MaxKey: return try setSourceKey(ExtendedJSONKeys.maxKey.rawValue, andEncode: val)
        case let val as MinKey: return try setSourceKey(ExtendedJSONKeys.minKey.rawValue, andEncode: val)
        case let val as Code: return try setSourceKey(ExtendedJSONKeys.code.rawValue, andEncode: val)
        case let val as BSONArray: return try setSourceKey("__$arr__", andEncode: val)
        case let val as Document: return try setSourceKey("__$doc__", andEncode: val)
        case let val as String: return try setSourceKey("__$str__", andEncode: val)
        case let val as Bool: return try setSourceKey("__$bool__", andEncode: val)
        case let val as Null: return try setSourceKey("__$nil__", andEncode: val)
        default: throw BsonError<Document>.illegalArgument(message: "\(value) not of XJson type")
        }
    }

    internal static func encodeKeyedContainer<T>(to container: inout KeyedEncodingContainer<T>,
                                                 sourceMap: inout [String: String],
                                                 forKey key: T,
                                                 withValue value: ExtendedJSONRepresentable?) throws {
        func setSourceKey<V>(_ xKey: String,
                             andEncode value: V?) throws where V: ExtendedJSONRepresentable {
            sourceMap[key.stringValue] = xKey
            if let value = value {
                try container.encode(value as V, forKey: key)
            } else {
                try container.encodeNil(forKey: key)
            }
        }

        switch value {
        case let val as ObjectId: try setSourceKey(ExtendedJSONKeys.objectid.rawValue, andEncode: val)
        case let val as Symbol: try setSourceKey(ExtendedJSONKeys.symbol.rawValue, andEncode: val)
        case let val as Decimal: try setSourceKey(ExtendedJSONKeys.numberDecimal.rawValue, andEncode: val)
        case let val as Double: try setSourceKey(ExtendedJSONKeys.numberDouble.rawValue, andEncode: val)
        case let val as Int32: try setSourceKey(ExtendedJSONKeys.numberInt.rawValue, andEncode: val)
        case let val as Int64: try setSourceKey(ExtendedJSONKeys.numberLong.rawValue, andEncode: val)
        case let val as Int: try setSourceKey(ExtendedJSONKeys.numberLong.rawValue, andEncode: val)
        case let val as RegularExpression: try setSourceKey(ExtendedJSONKeys.regex.rawValue, andEncode: val)
        case let val as UUID: try setSourceKey(ExtendedJSONKeys.binary.rawValue, andEncode: val)
        case let val as Date: try setSourceKey(ExtendedJSONKeys.date.rawValue, andEncode: val)
        case let val as Binary: try setSourceKey(ExtendedJSONKeys.binary.rawValue, andEncode: val)
        case let val as DBPointer: try setSourceKey(ExtendedJSONKeys.dbPointer.rawValue, andEncode: val)
        case let val as Timestamp: try setSourceKey(ExtendedJSONKeys.timestamp.rawValue, andEncode: val)
        case let val as DBRef: try setSourceKey(ExtendedJSONKeys.dbRef.rawValue, andEncode: val)
        case let val as Undefined: try setSourceKey(ExtendedJSONKeys.undefined.rawValue, andEncode: val)
        case let val as MaxKey: try setSourceKey(ExtendedJSONKeys.maxKey.rawValue, andEncode: val)
        case let val as MinKey: try setSourceKey(ExtendedJSONKeys.minKey.rawValue, andEncode: val)
        case let val as Code: try setSourceKey(ExtendedJSONKeys.code.rawValue, andEncode: val)
        case let val as BSONArray: try setSourceKey("__$arr__", andEncode: val)
        case let val as Document: try setSourceKey("__$doc__", andEncode: val)
        case let val as String: try setSourceKey("__$str__", andEncode: val)
        case let val as Bool: try setSourceKey("__$bool__", andEncode: val)
        case let val as Null: try setSourceKey("__$nil__", andEncode: val)
        default: break
        }
    }

    internal static func decode(from container: inout UnkeyedDecodingContainer,
                                decodingTypeString: String) throws -> ExtendedJSONRepresentable {
        func decode<V>(_ type: V.Type) throws -> V where V: ExtendedJSONRepresentable {
            return try container.decode(type)
        }
        switch decodingTypeString {
        case ExtendedJSONKeys.objectid.rawValue: return try decode(ObjectId.self)
        case ExtendedJSONKeys.symbol.rawValue: return try decode(Symbol.self)
        case ExtendedJSONKeys.numberDecimal.rawValue: return try decode(Decimal.self)
        case ExtendedJSONKeys.numberInt.rawValue: return try decode(Int.self)
        case ExtendedJSONKeys.numberLong.rawValue: return try decode(Int64.self)
        case ExtendedJSONKeys.numberDouble.rawValue: return try decode(Double.self)
        case ExtendedJSONKeys.timestamp.rawValue: return try decode(Timestamp.self)
        case ExtendedJSONKeys.dbPointer.rawValue: return try decode(DBPointer.self)
        case ExtendedJSONKeys.regex.rawValue: return try decode(RegularExpression.self)
        case ExtendedJSONKeys.date.rawValue: return try decode(Date.self)
        case ExtendedJSONKeys.binary.rawValue: return try decode(Binary.self)
        case ExtendedJSONKeys.undefined.rawValue: return try decode(Undefined.self)
        case ExtendedJSONKeys.minKey.rawValue: return try decode(MinKey.self)
        case ExtendedJSONKeys.maxKey.rawValue: return try decode(MaxKey.self)
        case ExtendedJSONKeys.dbRef.rawValue: return try decode(DBRef.self)
        case ExtendedJSONKeys.code.rawValue: return try decode(Code.self)
        case "__$arr__": return try decode(BSONArray.self)
        case "__$doc__": return try decode(Document.self)
        case "__$str__": return try decode(String.self)
        case "__$bool__": return try decode(Bool.self)
        case "__$nil__": return try decode(Null.self)
        default: throw BsonError<Document>.illegalArgument(message: "unknown key found while decoding bson: \(decodingTypeString)")
        }
    }

    internal static func decode<T>(from container: KeyedDecodingContainer<T>,
                                   decodingTypeString: String,
                                   forKey key: T) throws -> ExtendedJSONRepresentable {
        func decode<V>(_ type: V.Type) throws -> V where V: ExtendedJSONRepresentable {
            return try container.decode(type, forKey: key)
        }

        switch decodingTypeString {
        case ExtendedJSONKeys.objectid.rawValue: return try decode(ObjectId.self)
        case ExtendedJSONKeys.symbol.rawValue: return try decode(Symbol.self)
        case ExtendedJSONKeys.numberDecimal.rawValue: return try decode(Decimal.self)
        case ExtendedJSONKeys.numberInt.rawValue: return try decode(Int.self)
        case ExtendedJSONKeys.numberLong.rawValue: return try decode(Int64.self)
        case ExtendedJSONKeys.numberDouble.rawValue: return try decode(Double.self)
        case ExtendedJSONKeys.timestamp.rawValue: return try decode(Timestamp.self)
        case ExtendedJSONKeys.dbPointer.rawValue: return try decode(DBPointer.self)
        case ExtendedJSONKeys.regex.rawValue: return try decode(RegularExpression.self)
        case ExtendedJSONKeys.date.rawValue: return try decode(Date.self)
        case ExtendedJSONKeys.binary.rawValue: return try decode(Binary.self)
        case ExtendedJSONKeys.undefined.rawValue: return try decode(Undefined.self)
        case ExtendedJSONKeys.minKey.rawValue: return try decode(MinKey.self)
        case ExtendedJSONKeys.maxKey.rawValue: return try decode(MaxKey.self)
        case ExtendedJSONKeys.dbRef.rawValue: return try decode(DBRef.self)
        case ExtendedJSONKeys.code.rawValue: return try decode(Code.self)
        case "__$arr__": return try decode(BSONArray.self)
        case "__$doc__": return try decode(Document.self)
        case "__$str__": return try decode(String.self)
        case "__$bool__": return try decode(Bool.self)
        case "__$nil__": return try decode(Null.self)
        default: throw BsonError<Document>.illegalArgument(message: "unknown key found while decoding bson: \(decodingTypeString)")
        }
    }

    public static func decodeXJson(value: Any?) throws -> ExtendedJSONRepresentable {
        switch (value) {
        case let json as [String: Any]:
            if json.count == 0 {
                return Document()
            }

            var iterator = json.makeIterator()
            while let next = iterator.next() {
                if let key = ExtendedJSONKeys(rawValue: next.key) {
                    switch (key) {
                    case .objectid: return try ObjectId.fromExtendedJSON(xjson: json)
                    case .numberInt: return try Int32.fromExtendedJSON(xjson: json)
                    case .numberLong: return try Int64.fromExtendedJSON(xjson: json)
                    case .numberDouble: return try Double.fromExtendedJSON(xjson: json)
                    case .numberDecimal: return try Decimal.fromExtendedJSON(xjson: json)
                    case .date: return try Date.fromExtendedJSON(xjson: json)
                    case .binary: return try Binary.fromExtendedJSON(xjson: json)
                    case .timestamp: return try Timestamp.fromExtendedJSON(xjson: json)
                    case .regex: return try RegularExpression.fromExtendedJSON(xjson: json)
                    case .dbRef: return try DBRef.fromExtendedJSON(xjson: json)
                    case .minKey: return try MinKey.fromExtendedJSON(xjson: json)
                    case .maxKey: return try MaxKey.fromExtendedJSON(xjson: json)
                    case .undefined: return try Undefined.fromExtendedJSON(xjson: json)
                    case .code: return try Code.fromExtendedJSON(xjson: json)
                    case .symbol: return try Symbol.fromExtendedJSON(xjson: json)
                    case .dbPointer: return try DBPointer.fromExtendedJSON(xjson: json)
                    }
                }
            }

            return try Document(extendedJson: json)
        case is NSNull, nil:
            return try Null.fromExtendedJSON(xjson: NSNull())
        case is [Any]:
            return try BSONArray.fromExtendedJSON(xjson: value!)
        case is String:
            return try String.fromExtendedJSON(xjson: value!)
        case is Bool:
            return try Bool.fromExtendedJSON(xjson: value!)
        case let value as ExtendedJSONRepresentable:
            return value
        default:
            throw BsonError.parseValueFailure(value: value, attemptedType: Document.self)
        }
    }
}

// MARK: - Helpers
internal enum ExtendedJSONKeys: String {
    case objectid = "$oid",
    symbol = "$symbol",
    numberInt = "$numberInt",
    numberLong = "$numberLong",
    numberDouble = "$numberDouble",
    numberDecimal = "$numberDecimal",
    date = "$date",
    binary = "$binary",
    code = "$code",
    timestamp = "$timestamp",
    regex = "$regularExpression",
    dbPointer = "$dbPointer",
    dbRef = "$ref",
    minKey = "$minKey",
    maxKey = "$maxKey",
    undefined = "$undefined"
}

// MARK: ISO8601

internal extension DateFormatter {

    static let iso8601DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
