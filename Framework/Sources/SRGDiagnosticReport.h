//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTimeMeasurement.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGDiagnosticReport : NSObject

- (void)setBool:(BOOL)value forKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)number forKey:(NSString *)key;

- (void)setURL:(NSURL *)URL forKey:(NSString *)key;

- (SRGTimeMeasurement *)timeMeasurementWithIdentifier:(NSString *)identifier;
- (SRGDiagnosticReport *)subreportWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
