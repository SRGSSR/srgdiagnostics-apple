//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A diagnostic report. You never instantiate reports directly but rather retrieve them from an `SRGDiagnosticsService`.
 *  Call the report `-submit` method when a diagnostic report is complete.
 */
@interface SRGDiagnosticReport : NSObject <NSCopying>

/**
 *  Associate primitive values with keys.
 */
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

/**
 *  Associate objects with keys.
 */
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)number forKey:(NSString *)key;
- (void)setURL:(NSURL *)URL forKey:(NSString *)key;

/**
 *  Start / stop a measurement, saving associated time information under the specified key.
 *
 *  @discussion If a measurement is not stopped, it will be ignored when the report is submitted.
 */
- (void)startTimeMeasurementForKey:(NSString *)key;
- (void)stopTimeMeasurementForKey:(NSString *)key;

/**
 *  Return a subreport with the specified name. An empty subreport is created if none existed for the specified name.
 */
- (SRGDiagnosticReport *)subreportForKey:(NSString *)key;

/**
 *  Submit the report with the associated service.
 *
 *  @discussion Calling `-submit` on a subreport does nothing.
 */
// TODO: Class hierarchy
- (void)submit;

@end

@interface SRGDiagnosticReport (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
