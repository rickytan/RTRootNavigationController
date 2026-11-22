import ObjectiveCConsumer
import RTRootNavigationController
import UIKit
import XCTest

final class SwiftPackageIntegrationTests: XCTestCase {
    @MainActor
    func testSwiftConsumerCanUseNavigationAndCategory() {
        let root = UIViewController()
        let navigation = RTRootNavigationController(rootViewController: root)
        let detail = UIViewController()

        navigation.pushViewController(detail, animated: false)
        detail.rt_disableInteractivePop = true

        XCTAssertTrue(root.rt_navigationController === navigation)
        XCTAssertTrue(detail.rt_navigationController === navigation)
        XCTAssertTrue(navigation.rt_topViewController === detail)
        XCTAssertEqual(navigation.rt_viewControllers.count, 2)
        XCTAssertTrue(detail.rt_disableInteractivePop)
    }

    @MainActor
    func testObjectiveCConsumerCanUseNavigationAndCategory() {
        XCTAssertTrue(ObjectiveCConsumerSmokeTest())
    }
}
