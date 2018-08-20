//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"
#import "SRGDiagnosticsService.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for internal use.
 */
@interface SRGDiagnosticReport (Private)

/**
 *  Create a report and associate it for submission by the specified service.
 */
- (instancetype)initWithDiagnosticsService:(SRGDiagnosticsService *)diagnosticsService;

@end

NS_ASSUME_NONNULL_END
