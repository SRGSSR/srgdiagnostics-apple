//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Diagnostic information.
 */
@interface SRGDiagnosticInformation : NSObject <NSCopying>

/**
 *  Associate primitive values with keys.
 */
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

/**
 *  Associate objects with keys. Setting `nil` removes the associated entry, if any.
 */
- (void)setString:(nullable NSString *)string forKey:(NSString *)key;
- (void)setNumber:(nullable NSNumber *)number forKey:(NSString *)key;
- (void)setURL:(nullable NSURL *)URL forKey:(NSString *)key;

/**
 *  Start / stop a time measurement, saving the associated value under the specified key.
 *
 *  @discussion If a measurement is not stopped, it will be ignored when the report is submitted.
 */
- (void)startTimeMeasurementForKey:(NSString *)key;
- (void)stopTimeMeasurementForKey:(NSString *)key;

/**
 *  Return nested information under the specified key.
 */
- (SRGDiagnosticInformation *)informationForKey:(NSString *)key;

/**
 *  Return report information as a dictionary serializable to JSON.
 */
- (NSDictionary<NSString *, id> *)JSONDictionary;

@end

NS_ASSUME_NONNULL_END
