//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnostics.h"

#import "NSBundle+SRGDiagnostics.h"

NSString *SRGDiagnosticsMarketingVersion(void)
{
    return NSBundle.srg_diagnosticsBundle.infoDictionary[@"CFBundleShortVersionString"];
}
