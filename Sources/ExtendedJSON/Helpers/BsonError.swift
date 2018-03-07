//
//  BsonError.swift
//  ExtendedJSON
//

import Foundation

public enum ExtendedJSONRepresentableError<T, U> {
    case incompatibleTypeFailure(attemptedType: T.Type, actualType: U.Type, actualValue: ExtendedJSONRepresentable)
}

// MARK: - XJson Error Descriptions
extension ExtendedJSONRepresentableError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incompatibleTypeFailure(let attemptedType, let actualType, let actualValue):
            return "Attempted conversion from \(actualType) to \(attemptedType) for value \(actualValue) failed"
        }
    }
}

public enum BsonError<T> {
    case illegalArgument(message: String)
    case parseValueFailure(value: Any?, attemptedType: T.Type)
}

// MARK: - Bson Error Descriptions
extension BsonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .illegalArgument(let message):
            return message
         case .parseValueFailure(let value, let attemptedType):
            return "ExtendedJSON \(value ?? "nil") is not valid \(attemptedType)"
        }
    }
}

