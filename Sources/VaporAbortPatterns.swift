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
    case entity(named: CustomStringConvertible)
    case custom(status: Status, name: String)
    case stub(named: CustomStringConvertible)

    public var name: String {
        switch self {
            case .parameter(let name):
                return name.description
            case .config(let name):
                return name.description
            case .dropletService(let name):
                return name.description
            case .entity(let name):
                return name.description
            case .stub(let name):
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
            case .entity:
                return .notFound
            case .stub:
                return .notImplemented
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
            case .entity(let name):
                return "'\(name)' not found"
            case .stub(let name):
                return "Not implemented '\(name)'"
            case .custom(_, let name):
                return "Missing '\(name)'"
        }
    }
}

extension Abort {
    
    public static func missing(_ missing: Missing) -> AbortError {
        return missingItem(missing)
    }

    public static func missingItem(_ missing: MissingItem) -> AbortError {
        return Abort(missing.status, reason: missing.reason)
    }
}
