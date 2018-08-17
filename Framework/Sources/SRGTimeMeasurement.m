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

- (void)start
{
    self.startDate = [NSDate date];
    self.endDate = nil;
}

- (void)stop
{
    self.endDate = [NSDate date];
}

- (void)measure:(void (^)(void))block
{
    [self start];
    block();
    [self stop];
}

@end
