import XCTest
import Solana

class sendSPLTokens: XCTestCase {
    var endpoint = RPCEndpoint.devnetSolana
    var solana: Solana!
    var signer: Signer!
    
    override func setUpWithError() throws {
        let wallet: TestsWallet = .devnet
        solana = Solana(router: NetworkingRouter(endpoint: endpoint))
        signer = HotAccount(phrase: wallet.testAccount.components(separatedBy: " "))!
        _ = try solana.api.requestAirdrop(account: signer.publicKey.base58EncodedString, lamports: 100.toLamport(decimals: 9))?.get()
    }
}
