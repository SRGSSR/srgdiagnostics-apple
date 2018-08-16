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
        s_bundle = [NSBundle bundleForClass:[SRGDiagnosticsService class]];
    });
    return s_bundle;
}

@end
