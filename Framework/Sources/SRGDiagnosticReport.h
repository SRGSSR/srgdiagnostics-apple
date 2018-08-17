//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTimeMeasurement.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGDiagnosticReport : NSObject

- (SRGTimeMeasurement *)timeMeasurementWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
