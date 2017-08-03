import Foundation
import Vapor
import HTTP

public protocol MissingItem {
    var name: String { get }
    var status: Status { get }
    var reason: String? { get }
}

public enum Missing: MissingItem {

    case parameter(named: CustomStringConvertible)
    case config(named: CustomStringConvertible)
    case dropletService(named: CustomStringConvertible)
    case custom(status: Status, name: String)

    public var name: String {
        switch self {
            case .parameter(let name):
                return name.description
            case .config(let name):
                return name.description
            case .dropletService(let name):
                return name.description
            case .custom(_, let name):
                return name.description
        }
    }

    public var status: Status {
        switch self {
            case .parameter:
                return .badRequest
            case .config, .dropletService:
                return .internalServerError
            case .custom(let status, _):
                return status
        }
    }

    public var reason: String? {
        switch self {
            case .parameter(let name):
                return "Missing parameter '\(name)'"
            case .config(let name):
                return "Missing config '\(name)'"
            case .dropletService(let name):
                return "Missing service '\(name)'"
            case .custom(_, let name):
                return "Missing '\(name)'"
        }
    }
}

extension Abort {
    public static func missing(_ missing: MissingItem) -> AbortError {
        return Abort(missing.status, reason: missing.reason)
    }
}
