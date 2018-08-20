//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticsService.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Private interface for internal use.
 */
@interface SRGDiagnosticsService (Private)

/**
 *  Submit the specified report.
 */
- (void)prepareToSubmitReport:(SRGDiagnosticReport *)report;

@end

NS_ASSUME_NONNULL_END
