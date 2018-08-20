//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A diagnostics service provides a way to create and submit diagnostic reports. When creating a service, a block
 *  must be registered to specify how a report must be submitted (e.g. saved to a file, logged to a console or sent
 *  to a webservice).
 *
 *  Reports are stored for the lifetime of the application. If a report cannot be submitted, the service will periodically
 *  retry until it succeeds.
 */
@interface SRGDiagnosticsService : NSObject

/**
 *  Register a service with a given name and submission block.
 *
 *  @param name            The name which the service must be registered under.
 *  @param submissionBlock The block which is called when submitting a report. Report information is supplied as a
 *                         dictionary which can readily be serialized to JSON. After successful or failed submission
 *                         `completionBlock` must be called so that the service is informed that the report has been
 *                         processed. If the `success` boolean is set to `YES`, the report will be discarded, otherwise
 *                         the service will later attempt to submit it again. Note that the block can be called on
 *                         any thread.
 *
 *  @discussion Registration replaces any existing registration for the specified name.
 */
+ (void)registerServiceWithName:(NSString *)name submissionBlock:(void (^)(NSDictionary *JSONDictionary, void (^completionBlock)(BOOL success)))submissionBlock;

/**
 *  Retrieve the service registered under the specified name, if any.
 */
+ (nullable SRGDiagnosticsService *)serviceWithName:(NSString *)name;

/**
 *  Return a report with the specified name. An empty report is created if none existed for the specified name.
 *
 *  @dicussion Call the report `-submit` method to finish and submit it.
 */
- (SRGDiagnosticReport *)reportWithName:(NSString *)name;

/**
 *  Ask the service to submit still pending reports.
 *
 *  @discussion The service periodically submit pending reports. If a submission is already being made, this method
 *              does nothing.
 */
- (void)submitPendingReports;

@end

@interface SRGDiagnosticsService (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
