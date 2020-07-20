//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Undefined time interval (measurement not started or not finished yet).
 */
static NSTimeInterval const SRGTimeMeasurementUndefined = -1.;

/**
 *  Internal class for time measurements. Valid measurements start with a `-start` and end with a `-stop`.
 */
@interface SRGTimeMeasurement : NSObject

/**
 *  Start a time measurement.
 *
 *  @discussion Until stopped, the measured time is `SRGTimeMeasurementUndefined`. Attempting to start an already started
 *              measurement does nothing.
 */
- (void)start;

/**
 *  Stop a time measurement.
 *
 *  @discussion Attempting to stop a non-started measurement does noting.
 */
- (void)stop;

/**
 *  The time measurement, or `SRGTimeMeasurementUndefined` if not determined yet.
 */
- (NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
