#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

@interface BackNavigationUITests : XCTestCase
@end

@implementation BackNavigationUITests

- (void)setUp
{
    [super setUp];
    self.continueAfterFailure = NO;
    XCUIDevice.sharedDevice.orientation = UIDeviceOrientationPortrait;
}

- (void)assertBackNavigationFromCell:(NSString *)cellTitle button:(NSString *)buttonIdentifier
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    XCUIElement *cell = app.cells[cellTitle];
    XCTAssertTrue([cell waitForExistenceWithTimeout:30], @"%@", app.debugDescription);
    [cell tap];

    XCUIElement *backButton = app.buttons[buttonIdentifier];
    XCTAssertTrue([backButton waitForExistenceWithTimeout:30], @"%@", app.debugDescription);
    XCTAssertTrue(backButton.hittable, @"%@", app.debugDescription);
    XCTAssertGreaterThan(CGRectGetMidX(backButton.frame), CGRectGetWidth(app.frame) * 0.75);
    [backButton tap];

    XCTAssertTrue([cell waitForExistenceWithTimeout:30], @"%@", app.debugDescription);
    XCTAssertTrue(cell.hittable, @"%@", app.debugDescription);
}

- (void)testDefaultBackButtonOnOuterDisplay
{
    [self assertBackNavigationFromCell:@"Normal" button:@"Back"];
}

- (void)testCustomBackButtonOnOuterDisplay
{
    [self assertBackNavigationFromCell:@"Disable Interactive Pop" button:@"custom-back"];
}

@end
