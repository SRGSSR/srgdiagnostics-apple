//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGDiagnostics/SRGDiagnostics.h>
#import <XCTest/XCTest.h>

@interface SRGDiagnosticInformationTestCase : XCTestCase

@end

@implementation SRGDiagnosticInformationTestCase

#pragma mark Tests

- (void)testEmptyInformation
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    XCTAssertEqualObjects([information JSONDictionary], @{});
}

- (void)testFilledInformation
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    [information setBool:YES forKey:@"boolean"];
    [information setInteger:1012 forKey:@"integer"];
    [information setFloat:36.5678f forKey:@"float"];
    [information setDouble:107.1234 forKey:@"double"];
    [information setString:@"Hello, World!" forKey:@"string"];
    [information setNumber:@7654.987 forKey:@"number"];
    [information setURL:[NSURL URLWithString:@"https://www.apple.com"] forKey:@"url"];
    NSDictionary *expectedDictionary = @{ @"boolean" : @YES,
                                          @"integer" : @1012,
                                          @"float" : @36.5678f,
                                          @"double" : @107.1234,
                                          @"string" : @"Hello, World!",
                                          @"number" : @7654.987,
                                          @"url" : @"https://www.apple.com" };
    XCTAssertEqualObjects([information JSONDictionary], expectedDictionary);
}

- (void)testTimeMeasurement
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    [information startTimeMeasurementForKey:@"time"];
    [NSThread sleepForTimeInterval:1.];
    [information stopTimeMeasurementForKey:@"time"];
    NSDictionary *expectedDictionary = @{ @"time" : @1000. };
    XCTAssertEqualObjects([information JSONDictionary], expectedDictionary);
}

- (void)testNestedInformation
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    [information setString:@"parent" forKey:@"title"];
    SRGDiagnosticInformation *nestedInformation = [information informationForKey:@"nestedInformation"];
    [nestedInformation setString:@"child" forKey:@"subtitle"];
    NSDictionary *expectedDictionary = @{ @"title" : @"parent",
                                          @"nestedInformation" : @{ @"subtitle" : @"child" } };
    XCTAssertEqualObjects([information JSONDictionary], expectedDictionary);
}

- (void)testPlayInformation
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    [information setString:@"Letterbox/iOS/1.9" forKey:@"player"];
    [information setString:@"iPhone 6" forKey:@"device"];
    [information setString:@"urn:rts:video:12345" forKey:@"urn"];
    [information setString:@"2011-07-11T14:18:47+02:00" forKey:@"clientTime"];
    [information setString:@"3g" forKey:@"networkType"];
    [information setString:@"success" forKey:@"result"];
    
    SRGDiagnosticInformation *ILErrorInformation = [information informationForKey:@"ilError"];
    [ILErrorInformation setString:@"GEOBLOCK" forKey:@"blockReason"];
    [ILErrorInformation setString:@"111 222" forKey:@"varnish"];
    [ILErrorInformation setBool:YES forKey:@"playableAbroad"];
    
    SRGDiagnosticInformation *networkErrorInformation = [information informationForKey:@"networkError"];
    [networkErrorInformation setString:@"https://domain.com/resource/path" forKey:@"url"];
    [networkErrorInformation setInteger:404 forKey:@"responseCode"];
    [networkErrorInformation setString:@"222 333" forKey:@"varnish"];
    [networkErrorInformation setString:@"A network error has been encountered" forKey:@"message"];
    
    SRGDiagnosticInformation *parsingErrorInformation = [information informationForKey:@"parsingError"];
    [parsingErrorInformation setString:@"https://domain.com/resource/path" forKey:@"url"];
    [parsingErrorInformation setInteger:12 forKey:@"line"];
    [parsingErrorInformation setString:@"A parsing error has been encountered" forKey:@"message"];
    
    SRGDiagnosticInformation *playerErrorInformation = [information informationForKey:@"playerError"];
    [playerErrorInformation setString:@"https://domain.com/resource/path" forKey:@"url"];
    [playerErrorInformation setString:@"1000kbps" forKey:@"variant"];
    [playerErrorInformation setString:@"https://domain.com/license" forKey:@"licenseUrl"];
    [playerErrorInformation setString:@"A player error has been encountered" forKey:@"message"];
    
    [information setBool:YES forKey:@"noPlayableResourceFound"];
    
    SRGDiagnosticInformation *timeInformation = [information informationForKey:@"time"];
    
    [timeInformation startTimeMeasurementForKey:@"clickToPlay"];
    [NSThread sleepForTimeInterval:0.5];
    [timeInformation stopTimeMeasurementForKey:@"clickToPlay"];
    
    [timeInformation startTimeMeasurementForKey:@"il"];
    [NSThread sleepForTimeInterval:0.6];
    [timeInformation stopTimeMeasurementForKey:@"il"];
    
    [timeInformation startTimeMeasurementForKey:@"token"];
    [NSThread sleepForTimeInterval:0.7];
    [timeInformation stopTimeMeasurementForKey:@"token"];
    
    [timeInformation startTimeMeasurementForKey:@"media"];
    [NSThread sleepForTimeInterval:0.8];
    [timeInformation stopTimeMeasurementForKey:@"media"];
    
    [timeInformation startTimeMeasurementForKey:@"drm"];
    [NSThread sleepForTimeInterval:0.9];
    [timeInformation stopTimeMeasurementForKey:@"drm"];
    
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
    XCTAssertEqualObjects([information JSONDictionary], expectedDictionary);
}

- (void)testCopy
{
    SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
    [information setString:@"parent" forKey:@"title"];
    [[information informationForKey:@"nestedInformation"] setString:@"child" forKey:@"title"];
    
    [information startTimeMeasurementForKey:@"time"];
    [NSThread sleepForTimeInterval:1.];
    [information stopTimeMeasurementForKey:@"time"];
    
    SRGDiagnosticInformation *informationCopy = [information copy];
    NSDictionary *expectedDictionary = @{ @"title" : @"parent",
                                          @"nestedInformation" : @{ @"subtitle" : @"child" },
                                          @"time" : @1000. };
    XCTAssertEqualObjects([informationCopy JSONDictionary], expectedDictionary);
}

// TODO: Test:
//   - No change after submission (deep copy)
//   - Several reports (whose submission never complete) with the same name (all must be added to pending items)
//   - Multiple submissions
//   - Create new report with same name while another one with the same name is still pending

@end
