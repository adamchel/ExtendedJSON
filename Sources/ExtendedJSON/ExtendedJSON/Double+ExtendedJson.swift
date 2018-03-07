//
//  Double+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Double: ExtendedJSONRepresentable {
    enum CodingKeys: String, CodingKey {
        case numberDouble = "$numberDouble"
    }

    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let value = json[ExtendedJSONKeys.numberDouble.rawValue] as? String,
            let doubleValue = Double(value),
            json.count == 1 else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Double.self)
        }

        return doubleValue
    }

    public var toExtendedJSON: Any {
        return [ExtendedJSONKeys.numberDouble.rawValue: String(self)]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(try container.decode(Double.self, forKey: CodingKeys.numberDouble))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self, forKey: CodingKeys.numberDouble)
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Double {
            return self == other || (self.isNaN && other.isNaN)
        }

        return false
    }
}
