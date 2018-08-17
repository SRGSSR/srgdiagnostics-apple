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

@end
