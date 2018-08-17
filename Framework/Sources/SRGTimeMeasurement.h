//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGTimeMeasurement : NSObject

- (void)start;
- (void)stop;

- (void)measure:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
