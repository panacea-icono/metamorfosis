import XCTest
@testable import MetamorfosisCore

final class MetamorfosisCoreTests: XCTestCase {
    func testPing() {
        XCTAssertEqual(MetamorfosisCore.ping(), "ok")
    }
}
