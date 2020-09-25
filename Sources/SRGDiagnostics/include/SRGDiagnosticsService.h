//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Standard time intervals for automatic report submission.
 */
static const NSTimeInterval SRGDiagnosticsDefaultSubmissionInterval = 30.;
static const NSTimeInterval SRGDiagnosticsMinimumSubmissionInterval = 10.;
static const NSTimeInterval SRGDiagnosticsDisabledSubmissionInterval = DBL_MAX;

/**
 *  A diagnostics service provides a way to create and submit diagnostic reports. A service, identified by a name,
 *  is created on the fly when accessed for the first time, and remains in existence for the lifetime of the application.
 *  Several services can coexist in an application, each submitting diagnostic reports in a different way. The submission
 *  process itself can take various forms, from webservice request to file logging, for example.
 *
 *  Once a service has been retrieved, a report can be created or retrived by its name. This makes it possible to access
 *  and fill report information from any part of the application in a decentralized way. Once a report is complete, marking
 *  it as finished informs the service that it can submit it when possible.
 *
 *  Submission is made on a periodic basis. For each finished report which has not been successfully submitted yet, the
 *  service will attempt to process it, calling a block letting you customize how submission actually occurs. Once it
 *  has been successfully submitted, a report is automatically discarded.
 *
 *  Diagnostics service and reports can be created and accessed from arbitrary threads.
 */
@interface SRGDiagnosticsService : NSObject

/**
 *  Retrieve a service for the specified name (creating the service if it did not exist yet).
 */
+ (SRGDiagnosticsService *)serviceWithName:(NSString *)name;

/**
 *  Return a report with the specified name. An empty report is created if none existed for the specified name.
 *
 *  @discussion Call the report `-finish` method to finish the report and let the service submit it.
 */
- (SRGDiagnosticReport *)reportWithName:(NSString *)name;

/**
 *  Block which gets called when a report needs to be submitted. Implementations (which might be asynchronous) must call
 *  the provided completion block when done. If the associated `success` boolean is set to `YES`, the report is discarded,
 *  otherwise the service will attempt submitting it again until it succeeds.
 *
 *  @discussion If no block has been assigned, reports will simply be discarded when submitted.
 */
@property (nonatomic, copy, nullable) void (^submissionBlock)(NSDictionary *JSONDictionary, void (^completionBlock)(BOOL success));

/**
 *  The interval at which finished reports are submitted. Default is `SRGDiagnosticsDefaultSubmissionInterval`. Use
 *  `SRGDiagnosticsDisabledSubmissionInterval` to disable periodic submission, in which case you are responsible of
 *  calling the `-submitFinishedReports` method when reports must be submitted.
 */
@property (nonatomic) NSTimeInterval submissionInterval;

/**
 *  Trigger submission of finished reports.
 *
 *  @discussion Reports are automatically submitted on a regular basis. Call this method to trigger submission earlier.
 */
- (void)submitFinishedReports;

@end

NS_ASSUME_NONNULL_END
