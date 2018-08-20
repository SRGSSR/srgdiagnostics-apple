//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSTimeInterval const SRGTimeMeasurementUndefined = -1.;

/**
 *  Internal class for time measurements. Valid measurements start with a `-start` and end with a `-stop`.
 */
@interface SRGTimeMeasurement : NSObject

/**
 *  Start / stop a time measurement.
 */
- (void)start;
- (void)stop;

/**
 *  The time measurement. `SRGTimeMeasurementUndefined` while invalid.
 */
- (NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
