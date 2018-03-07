//
//  Decimal+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Decimal: ExtendedJSONRepresentable {
    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let decimalString = json[ExtendedJSONKeys.numberDecimal.rawValue] as? String,
            let decimal = Decimal(string: decimalString),
            json.count == 1 else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Decimal.self)
        }

        return decimal
    }

    public var toExtendedJSON: Any {
        return [ExtendedJSONKeys.numberDecimal.rawValue: String(describing: self)]
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Decimal {
            return self == other
        }
        return false
    }
}
