import Foundation
import Beet

public struct Transfer {
    public static func compile() -> Data {
        var result = Data(capacity: 17) // FIXME: - capacity
        result.append(0x2) // program index
        let keyIndeces = [UInt8]([0, 1])
        result.append(Data.encodeLength(keyIndeces.count)) // key size
        result.append(contentsOf: keyIndeces) // keyIndeces
        result.append(UInt8(12))   // FIXME transfer data size

        result += Data([UInt8(truncatingIfNeeded: UInt32(2) >> 0),
                        UInt8(truncatingIfNeeded: UInt32(2) >> 8),
                        UInt8(truncatingIfNeeded: UInt32(2) >> 16),
                        UInt8(truncatingIfNeeded: UInt32(2) >> 24)]) // Program Index

        let lamports = 3000
        result += Data([UInt8(truncatingIfNeeded: UInt64(lamports) >> 0),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 8),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 16),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 24),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 32),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 40),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 48),
                        UInt8(truncatingIfNeeded: UInt64(lamports) >> 56)])

        return result
    }
}

public enum Commitment: String, Codable {
    case finalized
    case confirmed
    case processed
    @available(*, deprecated)
    case recent
}

public struct RequestConfiguration: Encodable {
    public let commitment: Commitment?
    public let encoding: String?
    public let dataSlice: DataSlice?
    public let filters: [[String: EncodableWrapper]]?
    public let limit: Int?
    public let before: String?
    public let until: String?
    public let skipPreflight: Bool?
    public let preflightCommitment: Commitment?

    public init?(
        commitment: Commitment? = nil,
        encoding: String? = nil,
        dataSlice: DataSlice? = nil,
        filters: [[String: EncodableWrapper]]? = nil,
        limit: Int? = nil,
        before: String? = nil,
        until: String? = nil,
        skipPreflight: Bool? = nil,
        preflightCommitment: Commitment? = nil
    ) {
        if commitment == nil
            && encoding == nil
            && dataSlice == nil
            && filters == nil
            && limit == nil
            && before == nil
            && until == nil
            && skipPreflight == nil
            && preflightCommitment == nil {
            return nil
        }
        self.commitment = commitment
        self.encoding = encoding
        self.dataSlice = dataSlice
        self.filters = filters
        self.limit = limit
        self.before = before
        self.until = until
        self.skipPreflight = skipPreflight
        self.preflightCommitment = preflightCommitment
    }
}

public struct DataSlice: Encodable {
    public let offset: Int
    public let length: Int
    public init(offset: Int, length: Int) {
        self.offset = offset
        self.length = length
    }
}
