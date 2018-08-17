//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTimeMeasurement.h"

@interface SRGTimeMeasurement ()

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@end

@implementation SRGTimeMeasurement

#pragma mark Getters and setters

- (NSTimeInterval)timeInterval
{
    @synchronized(self) {
        return [self.endDate timeIntervalSinceDate:self.startDate];
    }
}

#pragma mark Measurement

- (void)start
{
    @synchronized(self) {
        self.startDate = [NSDate date];
        self.endDate = nil;
    }
}

- (void)stop
{
    @synchronized(self) {
        self.endDate = [NSDate date];
    }
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; startDate = %@; endDate = %@>",
            [self class],
            self,
            self.startDate,
            self.endDate];
}

@end
