import Foundation
import Beet

public enum BufferLayoutError: Error {
    case NotImplemented
}
public protocol BufferLayout: Codable, BorshCodable {
    static var BUFFER_LENGTH: UInt64 { get }
}

public struct Buffer<T: BufferLayout>: Codable {
    public let value: T?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // decode parsedJSON
        if let parsedData = try? container.decode(T.self) {
            value = parsedData
            return
        }

        // Unable to get parsed data, fallback to decoding base64
        let stringData = (try? container.decode([String].self).first) ?? (try? container.decode(String.self))
        guard let string = stringData,
              let decodedData = Data(base64Encoded: string),
              decodedData.count >= T.BUFFER_LENGTH
        else {
            value = nil
            return
        }

        var reader = BinaryReader(bytes: Array(decodedData))
        value = try? T.init(from: &reader)
    }
}

public struct PureData: Decodable {
    public static var BUFFER_LENGTH: UInt64 = UInt64.min
    public let value: Data?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // Unable to get parsed data, fallback to decoding base64
        let stringData = (try? container.decode([String].self).first) ?? (try? container.decode(String.self))
        guard let string = stringData,
              let decodedData = Data(base64Encoded: string),
              decodedData.count >= PureData.BUFFER_LENGTH
        else {
            value = nil
            return
        }
        value = decodedData
    }
}
