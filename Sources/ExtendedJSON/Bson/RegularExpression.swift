//
//  NSRegularExpression+ExtendedJSON.swift
//  ExtendedJSON
//
//  Created by Jason Flax on 10/3/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

public final class RegularExpression: NSRegularExpression, ExtendedJSONRepresentable {
    enum CodingKeys: String, CodingKey {
        case regex = "$regex", pattern, options
    }

    public static func fromExtendedJSON(xjson: Any) throws -> ExtendedJSONRepresentable {
        guard let json = xjson as? [String: Any],
            let regex = json[ExtendedJSONKeys.regex.rawValue] as? [String: String],
            let pattern = regex["pattern"],
            let options = regex["options"],
            let regularExpression = try? RegularExpression(pattern: pattern,
                                                           options: NSRegularExpression.Options(options)),
            regex.count == 2 else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: NSRegularExpression.self)
        }

        return regularExpression
    }

    public func isEqual(toOther other: ExtendedJSONRepresentable) -> Bool {
        if let other = other as? NSRegularExpression {
            return self.pattern == other.pattern &&
                self.options == other.options
        }
        return false
    }

    override public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        try super.init(pattern: pattern, options: options)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: CodingKeys.regex)
        try self.init(pattern: try nestedContainer.decode(String.self,
                                                          forKey: CodingKeys.pattern),
                      options: NSRegularExpression.Options(try nestedContainer.decode(String.self,
                                                                                      forKey: CodingKeys.options)))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: CodingKeys.regex)
        try nestedContainer.encode(pattern, forKey: CodingKeys.pattern)
        try nestedContainer.encode(options.toExtendedJSON as? String, forKey: CodingKeys.options)
    }

    public var toExtendedJSON: Any {
        return [
            ExtendedJSONKeys.regex.rawValue: [
                "pattern": pattern,
                "options": options.toExtendedJSON
            ]
        ]
    }
}

extension NSRegularExpression.Options {
    private struct ExtendedJSONOptions {
        static let caseInsensitive =            "i"
        static let anchorsMatchLines =          "m"
        static let dotMatchesLineSeparators =   "s"
        static let allowCommentsAndWhitespace = "x"
    }

    internal var toExtendedJSON: Any {
        var description = ""
        if contains(.caseInsensitive) {
            description.append(ExtendedJSONOptions.caseInsensitive)
        }
        if contains(.anchorsMatchLines) {
            description.append(ExtendedJSONOptions.anchorsMatchLines)
        }
        if contains(.dotMatchesLineSeparators) {
            description.append(ExtendedJSONOptions.dotMatchesLineSeparators)
        }
        if contains(.allowCommentsAndWhitespace) {
            description.append(ExtendedJSONOptions.allowCommentsAndWhitespace)
        }

        return description
    }

    public init(_ extendedJsonString: String) {
        self = []
        if extendedJsonString.contains(ExtendedJSONOptions.caseInsensitive) {
            self.insert(.caseInsensitive)
        }
        if extendedJsonString.contains(ExtendedJSONOptions.anchorsMatchLines) {
            self.insert(.anchorsMatchLines)
        }
        if extendedJsonString.contains(ExtendedJSONOptions.dotMatchesLineSeparators) {
            self.insert(.dotMatchesLineSeparators)
        }
        if extendedJsonString.contains(ExtendedJSONOptions.allowCommentsAndWhitespace) {
            self.insert(.allowCommentsAndWhitespace)
        }
    }
}
