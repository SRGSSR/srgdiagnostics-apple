//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTimeMeasurement.h"

@interface SRGTimeMeasurement ()

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSTimeInterval timeInterval;

@end

@implementation SRGTimeMeasurement

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.timeInterval = SRGTimeMeasurementUndefined;
    }
    return self;
}

#pragma mark Measurement

- (void)start
{
    @synchronized(self) {
        if (self.startDate) {
            return;
        }
        
        self.timeInterval = SRGTimeMeasurementUndefined;
        self.startDate = NSDate.date;
    }
}

- (void)stop
{
    @synchronized(self) {
        if (! self.startDate) {
            return;
        }
        
        self.timeInterval = [NSDate.date timeIntervalSinceDate:self.startDate];
        self.startDate = nil;
    }
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; timeInterval = %@>",
            self.class,
            self,
            @(self.timeInterval)];
}

@end
