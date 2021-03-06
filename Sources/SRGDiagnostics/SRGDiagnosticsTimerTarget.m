//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticsTimerTarget.h"

@interface SRGDiagnosticsTimerTarget ()

@property (nonatomic, copy) void (^block)(NSTimer *);

@end

@implementation SRGDiagnosticsTimerTarget

- (instancetype)initWithBlock:(void (^)(NSTimer * _Nonnull))block
{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)fire:(NSTimer *)timer
{
    self.block ? self.block(timer) : nil;
}

@end
