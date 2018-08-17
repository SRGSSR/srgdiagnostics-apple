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

- (void)testEmptyReport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticReport alloc] init];
    XCTAssertEqualObjects([report JSONDictionary], @{});
}

- (void)testFilledReport
{
    SRGDiagnosticReport *report = [[SRGDiagnosticReport alloc] init];
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
    XCTAssertTrue([[report JSONDictionary] isEqualToDictionary:expectedDictionary]);
}

@end
