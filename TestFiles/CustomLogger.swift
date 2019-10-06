//
//  CustomLogger.Level
//

import Foundation

extension CustomLogger {

	public enum Level: Int, CaseIterable {

		case verbose = 0
		case debug
		case info
		case warning
		case error

	}

}


// MARK: - Comparable
extension CustomLogger.Level: Comparable {

	public static func <(lhs: CustomLogger.Level, rhs: CustomLogger.Level) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}

}


// MARK: - CustomStringConvertible
extension CustomLogger.Level: CustomStringConvertible {

	public var description: String {
		switch self {
		case .verbose:
			return "VERBOSE"
		case .debug:
			return "DEBUG"
		case .info:
			return "INFO"
		case .warning:
			return "WARNING"
		case .error:
			return "ERROR"
		}
	}

}
