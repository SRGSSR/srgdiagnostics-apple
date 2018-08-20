//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDiagnostics/SRGDiagnostics.h>
#import <XCTest/XCTest.h>

#import "SRGDiagnosticReport+Private.h"

@interface SRGDiagnosticReportTestCase : XCTestCase

@end

@implementation SRGDiagnosticReportTestCase

#pragma mark Setup and teardown

- (void)setUp
{
    [SRGDiagnosticsService registerServiceWithName:@"test" submissionBlock:^(NSDictionary * _Nonnull JSONDictionary, void (^ _Nonnull completionBlock)(BOOL success)) {
        completionBlock(YES);
    }];
}

#pragma mark Tests

- (void)testEmptyReport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    XCTAssertEqualObjects([report JSONDictionary], @{});
}

- (void)testFilledReport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    [report setBool:YES forKey:@"boolean"];
    [report setInteger:1012 forKey:@"integer"];
    [report setFloat:36.5678f forKey:@"float"];
    [report setDouble:107.1234 forKey:@"double"];
    [report setString:@"Hello, World!" forKey:@"string"];
    [report setNumber:@7654.987 forKey:@"number"];
    [report setURL:[NSURL URLWithString:@"https://www.apple.com"] forKey:@"url"];
    NSDictionary *expectedDictionary = @{ @"boolean" : @YES,
                                          @"integer" : @1012,
                                          @"float" : @36.5678f,
                                          @"double" : @107.1234,
                                          @"string" : @"Hello, World!",
                                          @"number" : @7654.987,
                                          @"url" : @"https://www.apple.com" };
    XCTAssertEqualObjects([report JSONDictionary], expectedDictionary);
}

- (void)testTimeMeasurement
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    [report startTimeMeasurementForKey:@"time"];
    [NSThread sleepForTimeInterval:1.];
    [report stopTimeMeasurementForKey:@"time"];
    NSDictionary *expectedDictionary = @{ @"time" : @1000. };
    XCTAssertEqualObjects([report JSONDictionary], expectedDictionary);
}

- (void)testUnstoppedTimeMeasurement
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    [report startTimeMeasurementForKey:@"time"];
    NSDictionary *expectedDictionary = @{ @"time" : @0. };
    XCTAssertEqualObjects([report JSONDictionary], expectedDictionary);
}

- (void)testSubreport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    [report setString:@"parent" forKey:@"title"];
    SRGDiagnosticReport *subreport = [report subreportForKey:@"subreport"];
    [subreport setString:@"child" forKey:@"subtitle"];
    NSDictionary *expectedDictionary = @{ @"title" : @"parent",
                                          @"subreport" : @{ @"subtitle" : @"child" } };
    XCTAssertEqualObjects([report JSONDictionary], expectedDictionary);
}

- (void)testPlayReport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticsService serviceWithName:@"test"] reportWithName:@"report"];
    [report setString:@"Letterbox/iOS/1.9" forKey:@"player"];
    [report setString:@"iPhone 6" forKey:@"device"];
    [report setString:@"urn:rts:video:12345" forKey:@"urn"];
    [report setString:@"2011-07-11T14:18:47+02:00" forKey:@"clientTime"];
    [report setString:@"3g" forKey:@"networkType"];
    [report setString:@"success" forKey:@"result"];
    
    SRGDiagnosticReport *ILErrorReport = [report subreportForKey:@"ilError"];
    [ILErrorReport setString:@"GEOBLOCK" forKey:@"blockReason"];
    [ILErrorReport setString:@"111 222" forKey:@"varnish"];
    [ILErrorReport setBool:YES forKey:@"playableAbroad"];
    
    SRGDiagnosticReport *networkErrorReport = [report subreportForKey:@"networkError"];
    [networkErrorReport setString:@"https://domain.com/resource/path" forKey:@"url"];
    [networkErrorReport setInteger:404 forKey:@"responseCode"];
    [networkErrorReport setString:@"222 333" forKey:@"varnish"];
    [networkErrorReport setString:@"A network error has been encountered" forKey:@"message"];
    
    SRGDiagnosticReport *parsingErrorReport = [report subreportForKey:@"parsingError"];
    [parsingErrorReport setString:@"https://domain.com/resource/path" forKey:@"url"];
    [parsingErrorReport setInteger:12 forKey:@"line"];
    [parsingErrorReport setString:@"A parsing error has been encountered" forKey:@"message"];
    
    SRGDiagnosticReport *playerErrorReport = [report subreportForKey:@"playerError"];
    [playerErrorReport setString:@"https://domain.com/resource/path" forKey:@"url"];
    [playerErrorReport setString:@"1000kbps" forKey:@"variant"];
    [playerErrorReport setString:@"https://domain.com/license" forKey:@"licenseUrl"];
    [playerErrorReport setString:@"A player error has been encountered" forKey:@"message"];
    
    [report setBool:YES forKey:@"noPlayableResourceFound"];
    
    SRGDiagnosticReport *timeReport = [report subreportForKey:@"time"];
    
    [timeReport startTimeMeasurementForKey:@"clickToPlay"];
    [NSThread sleepForTimeInterval:0.5];
    [timeReport stopTimeMeasurementForKey:@"clickToPlay"];
    
    [timeReport startTimeMeasurementForKey:@"il"];
    [NSThread sleepForTimeInterval:0.6];
    [timeReport stopTimeMeasurementForKey:@"il"];
    
    [timeReport startTimeMeasurementForKey:@"token"];
    [NSThread sleepForTimeInterval:0.7];
    [timeReport stopTimeMeasurementForKey:@"token"];
    
    [timeReport startTimeMeasurementForKey:@"media"];
    [NSThread sleepForTimeInterval:0.8];
    [timeReport stopTimeMeasurementForKey:@"media"];
    
    [timeReport startTimeMeasurementForKey:@"drm"];
    [NSThread sleepForTimeInterval:0.9];
    [timeReport stopTimeMeasurementForKey:@"drm"];
    
    NSDictionary *expectedDictionary = @{ @"player" : @"Letterbox/iOS/1.9",
                                          @"device" : @"iPhone 6",
                                          @"urn" : @"urn:rts:video:12345",
                                          @"clientTime" : @"2011-07-11T14:18:47+02:00",
                                          @"networkType" : @"3g",
                                          @"result" : @"success",
                                          @"ilError" : @{ @"blockReason" : @"GEOBLOCK",
                                                          @"varnish" : @"111 222",
                                                          @"playableAbroad" : @YES },
                                          @"networkError" : @{ @"url" : @"https://domain.com/resource/path",
                                                               @"responseCode" : @404,
                                                               @"varnish" : @"222 333",
                                                               @"message" : @"A network error has been encountered" },
                                          @"parsingError" : @{ @"url" : @"https://domain.com/resource/path",
                                                               @"line" : @12,
                                                               @"message" : @"A parsing error has been encountered" },
                                          @"playerError" : @{ @"url" : @"https://domain.com/resource/path",
                                                              @"variant" : @"1000kbps",
                                                              @"licenseUrl" : @"https://domain.com/license",
                                                              @"message" : @"A player error has been encountered" },
                                          @"noPlayableResourceFound" : @YES,
                                          @"time" : @{ @"clickToPlay" : @500.,
                                                       @"il" : @600.,
                                                       @"token" : @700.,
                                                       @"player" : @800.,
                                                       @"drm" : @900. }
                                          };
    XCTAssertEqualObjects([report JSONDictionary], expectedDictionary);
}

// TODO: Test:
//   - Copy (also with nested reports)
//   - No change after submission (deep copy)
//   - Several reports (whose submission never complete) with the same name (all must be added to pending items)
//   - Multiple submissions
//   - Create new report with same name while another one with the same name is still pending
//   - Time measurements: Start / stop; stop only; start only

@end
