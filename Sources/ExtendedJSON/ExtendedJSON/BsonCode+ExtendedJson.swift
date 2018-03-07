//
//  BsonCode+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/5/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension Code: ExtendedJSONRepresentable {
    enum CodingKeys: String, CodingKey {
        case code = "$code", scope = "$scope"
    }

    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let code = json[ExtendedJSONKeys.code.rawValue] as? String else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: Code.self)
        }

        if let scope = json["$scope"] {
            return Code(code: code,
                            scope: try Document.fromExtendedJSON(xjson: scope) as? Document)
        }

        return Code(code: code, scope: nil)
    }

    public var toExtendedJSON: Any {
        var code: [String: Any] = [
            ExtendedJSONKeys.code.rawValue: self.code
        ]

        if let scope = self.scope {
            code["$scope"] = scope.toExtendedJSON
        }

        return code
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(code: try container.decode(String.self, forKey: CodingKeys.code),
                  scope: try container.decodeIfPresent(Document.self, forKey: CodingKeys.scope))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.code, forKey: CodingKeys.code)
        try container.encodeIfPresent(self.scope, forKey: CodingKeys.scope)
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? Code {
            return self.code == other.code  && self.scope == other.scope
        }

        return false
    }
}
