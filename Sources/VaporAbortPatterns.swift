import Foundation
import Vapor

extension Abort {
    
    public static func missingParameter(_ parameter: CustomStringConvertible) -> AbortError {
        return Abort(.badRequest, reason: "Missing parameter '\(parameter)'")
    }
    
    public static func missingConfig(_ named: CustomStringConvertible) -> AbortError {
        return Abort(.internalServerError, reason: "Missing config '\(named)'")
    }
    
    public static func missingDropletService(_ named: CustomStringConvertible) -> AbortError {
        return Abort(.internalServerError, reason: "Missing droplet service '\(named)'")
    }
}
