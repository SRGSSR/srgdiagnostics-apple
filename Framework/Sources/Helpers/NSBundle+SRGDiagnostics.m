//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSBundle+SRGDiagnostics.h"

#import "SRGDiagnosticsService.h"

@implementation NSBundle (SRGDiagnostics)

#pragma mark Class methods

+ (instancetype)srg_diagnosticsBundle
{
    static NSBundle *s_bundle;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSString *bundlePath = [[NSBundle bundleForClass:SRGDiagnosticsService.class].bundlePath stringByAppendingPathComponent:@"SRGDiagnostics.bundle"];
        s_bundle = [NSBundle bundleWithPath:bundlePath];
        NSAssert(s_bundle, @"Please add SRGDiagnostics.bundle to your project resources");
    });
    return s_bundle;
}

@end
