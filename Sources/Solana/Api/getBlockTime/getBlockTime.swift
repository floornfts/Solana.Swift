import Foundation

public extension Api {
    /// Returns the estimated production time of a block.
    /// 
    /// Each validator reports their UTC time to the ledger 
    /// on a regular interval by intermittently adding a timestamp
    /// to a Vote for a particular block. A requested block's time 
    /// is calculated from the stake-weighted mean of the Vote timestamps
    /// in a set of recent blocks recorded on the ledger.
    /// 
    /// - Parameters:
    ///   - block: block, identified by Slot
    ///   - onComplete: A Result type of estimated production time, as `Date` or `nil` (timestamp is not available for this block)
    func getBlockTime(block: UInt64, onComplete: @escaping( (Result<Date?, Error>) -> Void)) {
        router.request(parameters: [block]) { (result: Result<Int64?, Error>) in
            switch result {
            case .success(let timestamp):
                guard let timestamp = timestamp else {
                    onComplete(.success(nil))
                    return
                }
                onComplete(.success(Date(timeIntervalSince1970: TimeInterval(timestamp))))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension Api {
    /// Returns the estimated production time of a block.
    /// 
    /// Each validator reports their UTC time to the ledger 
    /// on a regular interval by intermittently adding a timestamp
    /// to a Vote for a particular block. A requested block's time 
    /// is calculated from the stake-weighted mean of the Vote timestamps
    /// in a set of recent blocks recorded on the ledger.
    /// 
    /// - Parameters:
    ///   - block: block, identified by Slot
    /// - Returns: estimated production time, as `Date` or `nil` (timestamp is not available for this block)
    func getBlockTime(block: UInt64) async throws -> Date? {
        try await withCheckedThrowingContinuation { c in
            self.getBlockTime(block: block, onComplete: c.resume(with:))
        }
    }
}

public extension ApiTemplates {
    struct GetBlockTime: ApiTemplate {
        public init(block: UInt64) {
            self.block = block
        }

        public let block: UInt64

        public typealias Success = Date?

        public func perform(withConfigurationFrom apiClass: Api, completion: @escaping (Result<Success, Error>) -> Void) {
            apiClass.getBlockTime(block: block, onComplete: completion)
        }
    }
}
