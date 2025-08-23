import Foundation

extension String {
    @inlinable
    public var bytes: [UInt8] {
        if let data = data(using: String.Encoding.utf8, allowLossyConversion: true) {
            return Array(data)
        } else {
            return Array(utf8)
        }
    }
}
