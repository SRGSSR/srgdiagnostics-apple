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
- (instancetype)initWithDiagnosticsService:(nullable SRGDiagnosticsService *)diagnosticsService;

/**
 *  Return report information as a dictionary serializable to JSON.
 */
- (NSDictionary *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
