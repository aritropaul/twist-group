//
//  Error.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/13/21.
//

import Foundation

enum TwistError: Error {
    case failedToDecode
    case notAllowed
    case unexpectedError(code: Int)
}

extension TwistError: CustomStringConvertible {
    var description: String {
        switch self {
        case .failedToDecode:
            return "The Decoding Failed"
        case .notAllowed:
            return "This is not Allowed"
        case .unexpectedError(code: let code):
            return "Unexpected Error with code: \(code)"
        }
    }
}
