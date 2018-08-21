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

- (void)testServiceRetrieval
{
    NSString *name = NSUUID.UUID.UUIDString;
    SRGDiagnosticsService *service1 = [SRGDiagnosticsService serviceWithName:name];
    XCTAssertNotNil(service1);
    XCTAssertNil(service1.submissionBlock);
    
    SRGDiagnosticsService *service2 = [SRGDiagnosticsService serviceWithName:name];
    XCTAssertEqualObjects(service1, service2);
}

- (void)testReportCreation
{
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    
    SRGDiagnosticReport *report1 = [service reportWithName:@"report"];
    XCTAssertNotNil(report1);
    
    SRGDiagnosticReport *report2 = [service reportWithName:@"report"];
    XCTAssertEqualObjects(report1, report2);
}

- (void)testReportSuccessfulSubmission
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation fulfill];
    };
    
    SRGDiagnosticReport *report = [service reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testReportSubmissionAfterSubmissionWithoutReports
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    [service submitFinishedReports];
    
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation fulfill];
    };
    
    SRGDiagnosticReport *report = [service reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testMultipleReportSuccessfulSubmission
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    
    __block BOOL report1Submitted = NO;
    __block BOOL report2Submitted = NO;
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        
        if ([JSONDictionary[@"uid"] isEqualToString:@"report1"]) {
            report1Submitted = YES;
        }
        else if ([JSONDictionary[@"uid"] isEqualToString:@"report2"]) {
            report2Submitted = YES;
        }
        
        if (report1Submitted && report2Submitted) {
            [expectation fulfill];
        }
    };
    
    SRGDiagnosticReport *report1 = [service reportWithName:@"report1"];
    [report1 setString:@"report1" forKey:@"uid"];
    [report1 finish];
    
    SRGDiagnosticReport *report2 = [service reportWithName:@"report2"];
    [report2 setString:@"report2" forKey:@"uid"];
    [report2 finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testMultipleReportSuccessfulSubmissionWithNameReuse
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    
    __block BOOL report1Submitted = NO;
    __block BOOL report2Submitted = NO;
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        
        if ([JSONDictionary[@"uid1"] isEqualToString:@"report1"]) {
            XCTAssertNil(JSONDictionary[@"uid2"]);
            report1Submitted = YES;
        }
        else if ([JSONDictionary[@"uid2"] isEqualToString:@"report2"]) {
            XCTAssertNil(JSONDictionary[@"uid1"]);
            report2Submitted = YES;
        }
        
        if (report1Submitted && report2Submitted) {
            [expectation fulfill];
        }
    };
    
    SRGDiagnosticReport *report1 = [service reportWithName:@"report"];
    [report1 setString:@"report1" forKey:@"uid1"];
    [report1 finish];
    
    SRGDiagnosticReport *report2 = [service reportWithName:@"report"];
    [report2 setString:@"report2" forKey:@"uid2"];
    [report2 finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testUnfinishedReportSubmission
{
    
}

- (void)testSingleSubmission
{
    // Check that submission is made once for a report, not twice
}

- (void)testReportFailedFirstSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(NO);
        [expectation1 fulfill];
    };
    
    SRGDiagnosticReport *report = [service reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Second submission block called"];
    
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation2 fulfill];
    };
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testReportImmutabilityAfterSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First submission block called"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(NO);
        [expectation1 fulfill];
    };
    
    SRGDiagnosticReport *report = [service reportWithName:@"report"];
    [report setString:@"My report" forKey:@"title"];
    [report finish];
    
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Second submission block called"];
    
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        XCTAssertEqualObjects(JSONDictionary[@"title"], @"My report");
        completionBlock(YES);
        [expectation2 fulfill];
    };
    
    [report setString:@"Modified title" forKey:@"title"];
    [service submitFinishedReports];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

- (void)testPeriodicSubmission
{
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"First report submitted"];
    
    SRGDiagnosticsService *service = [SRGDiagnosticsService serviceWithName:NSUUID.UUID.UUIDString];
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation1 fulfill];
    };
    service.submissionInterval = 2.;
    
    SRGDiagnosticReport *report1 = [service reportWithName:@"report"];
    [report1 setString:@"My report" forKey:@"title"];
    [report1 finish];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Second report submitted"];
    
    service.submissionBlock = ^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL)) {
        completionBlock(YES);
        [expectation2 fulfill];
    };
    
    SRGDiagnosticReport *report2 = [service reportWithName:@"report"];
    [report2 setString:@"My other report" forKey:@"title"];
    [report2 finish];
    
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

@end
