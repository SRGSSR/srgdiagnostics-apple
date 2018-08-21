//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDiagnostics/SRGDiagnostics.h>
#import <XCTest/XCTest.h>

@interface SRGDiagnosticsServiceTestCase : XCTestCase

@end

@implementation SRGDiagnosticsServiceTestCase

#pragma mark Helpers

- (XCTestExpectation *)expectationForElapsedTimeInterval:(NSTimeInterval)timeInterval withHandler:(void (^)(void))handler
{
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Wait for %@ seconds", @(timeInterval)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        handler ? handler() : nil;
    });
    return expectation;
}

#pragma mark Tests

- (void)testRegistration
{
    NSString *name = NSUUID.UUID.UUIDString;
    XCTAssertNil([SRGDiagnosticsService serviceWithName:name]);
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        XCTFail(@"Must not be called on registration");
        completionBlock(YES);
    }];
    XCTAssertNotNil([SRGDiagnosticsService serviceWithName:name]);
}

- (void)testRegistrationOverride
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    NSString *name = NSUUID.UUID.UUIDString;
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        XCTFail(@"Must not be called since replaced");
        completionBlock(YES);
    }];
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation fulfill];
    }];
    
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testReportCreation
{
    NSString *name = NSUUID.UUID.UUIDString;
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
    }];
    
    SRGDiagnosticReport *report1 = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    XCTAssertNotNil(report1);
    
    SRGDiagnosticReport *report2 = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    XCTAssertEqualObjects(report1, report2);
}

- (void)testReportSuccessfulSubmission
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    NSString *name = NSUUID.UUID.UUIDString;
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation fulfill];
    }];
    
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testUnfinishedReportSubmission
{
    
}

- (void)testReportFailedFirstSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First submission block called"];
    
    NSString *name = NSUUID.UUID.UUIDString;
    
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(NO);
        [expectation1 fulfill];
    }];
    
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"First submission block called"];
    
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation2 fulfill];
    }];
    
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testReportImmutabilityAfterSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First submission block called"];
    
    NSString *name = NSUUID.UUID.UUIDString;
    
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(NO);
        [expectation1 fulfill];
    }];
    
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"First submission block called"];
    
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        XCTAssertEqualObjects(JSONDictionary[@"title"], @"My report");
        completionBlock(YES);
        [expectation2 fulfill];
    }];
    
    [report setString:@"Modified title" forKey:@"title"];
    [[SRGDiagnosticsService serviceWithName:name] submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testPeriodicSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First report submitted"];
    
    NSString *name = NSUUID.UUID.UUIDString;
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation1 fulfill];
    }];
    [SRGDiagnosticsService serviceWithName:name].submissionInterval = 2.;
    
    SRGDiagnosticReport *report1 = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report1 setString:@"My report" forKey:@"title"];
    [report1 finish];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Second report submitted"];
    
    [SRGDiagnosticsService registerServiceWithName:name submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation2 fulfill];
    }];
    
    SRGDiagnosticReport *report2 = [[SRGDiagnosticsService serviceWithName:name] reportWithName:@"report"];
    [report2 setString:@"My other report" forKey:@"title"];
    [report2 finish];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

// TODO: Tests above:
//   - Several reports (whose submission never complete) with the same name (all must be added to pending items)
//   - Multiple submissions
//   - Create new report with same name while another one with the same name is still pending

@end
