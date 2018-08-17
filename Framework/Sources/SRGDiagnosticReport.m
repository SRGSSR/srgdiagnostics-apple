//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

@interface SRGDiagnosticReport ()

@property (nonatomic) NSMutableDictionary<NSString *, SRGTimeMeasurement *> *timeMeasurements;

@end

@implementation SRGDiagnosticReport

- (SRGTimeMeasurement *)timeMeasurementWithIdentifier:(NSString *)identifier
{
    SRGTimeMeasurement *timeMeasurement = self.timeMeasurements[identifier];
    if (! timeMeasurement) {
        timeMeasurement = [[SRGTimeMeasurement alloc] init];
        self.timeMeasurements[identifier] = timeMeasurement;
    }
    return timeMeasurement;
}

@end
