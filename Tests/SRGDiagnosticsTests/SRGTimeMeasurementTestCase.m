//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

// Private framework header
#import "SRGTimeMeasurement.h"

@import XCTest;

@interface SRGTimeMeasurementTestCase : XCTestCase

@end

@implementation SRGTimeMeasurementTestCase

- (void)testTimeMeasurementCreation
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
}

- (void)testValidTimeMeasurement
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement start];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    XCTAssertEqualWithAccuracy([timeMeasurement timeInterval], 1., 0.1);
}

- (void)testUnstoppedTimeMeasurement
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement start];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
}

- (void)testUnstartedTimeMeasurement
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement stop];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
}

- (void)testRestartedTimeMeasurement
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement start];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    XCTAssertEqualWithAccuracy([timeMeasurement timeInterval], 1., 0.1);
    
    [timeMeasurement start];
    XCTAssertEqual([timeMeasurement timeInterval], SRGTimeMeasurementUndefined);
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    XCTAssertEqualWithAccuracy([timeMeasurement timeInterval], 1., 0.1);
}

- (void)testTimeMeasurementStartedTwice
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement start];
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement start];
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    XCTAssertEqualWithAccuracy([timeMeasurement timeInterval], 2., 0.1);
}

- (void)testTimeMeasurementStoppedTwice
{
    SRGTimeMeasurement *timeMeasurement = [[SRGTimeMeasurement alloc] init];
    [timeMeasurement start];
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    [NSThread sleepForTimeInterval:1.];
    [timeMeasurement stop];
    XCTAssertEqualWithAccuracy([timeMeasurement timeInterval], 1., 0.1);
}

@end
