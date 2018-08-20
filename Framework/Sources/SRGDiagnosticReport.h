//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticInformation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A diagnostic report. Call the report `-submit` method when a diagnostic report is complete.
 */
@interface SRGDiagnosticReport : SRGDiagnosticInformation

/**
 *  Finish the report.
 *
 *  @discussion A finished report cannot be changed afterwards.
 */
- (void)finish;

@end

NS_ASSUME_NONNULL_END
