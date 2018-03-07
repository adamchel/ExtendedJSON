//
//  Date+ExtenedJson.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Date: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let dateJson = json[ExtendedJSONKeys.date.rawValue] as? [String: String],
            let dateString = dateJson[ExtendedJSONKeys.numberLong.rawValue],
            let dateNum = Double(dateString),
            dateJson.count == 1 else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Date.self)
        }

        return Date(timeIntervalSince1970: dateNum)
    }

    public var toExtendedJSON: Any {
        return [
            ExtendedJSONKeys.date.rawValue: [
                ExtendedJSONKeys.numberLong.rawValue: String(Double(timeIntervalSince1970 * 1000))
            ]
        ]
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Date {
            return self == other
        }
        return false
    }
}
