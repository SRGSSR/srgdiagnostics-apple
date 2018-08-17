//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

#import "SRGTimeMeasurement.h"

@interface SRGDiagnosticReport ()

@property (nonatomic) NSMutableDictionary<NSString *, id> *values;
@property (nonatomic) NSMutableDictionary<NSString *, SRGTimeMeasurement *> *timeMeasurements;
@property (nonatomic) NSMutableDictionary<NSString *, SRGDiagnosticReport *> *subreports;

@end

@implementation SRGDiagnosticReport

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.values = [NSMutableDictionary dictionary];
        self.timeMeasurements = [NSMutableDictionary dictionary];
        self.subreports = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Report data

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @(value);
    }
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @(value);
    }
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @(value);
    }
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @(value);
    }
}

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = string;
    }
}

- (void)setNumber:(NSNumber *)number forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = number;
    }
}

- (void)setURL:(NSURL *)URL forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = URL.absoluteString;
    }
}

- (void)startTimeMeasurementWithIdentifier:(NSString *)identifier
{
    [[self timeMeasurementWithIdentifier:identifier] start];
}

- (void)stopTimeMeasurementWithIdentifier:(NSString *)identifier
{
    [[self timeMeasurementWithIdentifier:identifier] stop];
}

#pragma mark Time measurements

- (SRGTimeMeasurement *)timeMeasurementWithIdentifier:(NSString *)identifier
{
    @synchronized(self.timeMeasurements) {
        SRGTimeMeasurement *timeMeasurement = self.timeMeasurements[identifier];
        if (! timeMeasurement) {
            timeMeasurement = [[SRGTimeMeasurement alloc] init];
            self.timeMeasurements[identifier] = timeMeasurement;
        }
        return timeMeasurement;
    }
}

- (SRGDiagnosticReport *)subreportWithIdentifier:(NSString *)identifier
{
    @synchronized(self.subreports) {
        SRGDiagnosticReport *subreport = self.subreports[identifier];
        if (! subreport) {
            subreport = [[SRGDiagnosticReport alloc] init];
            self.subreports[identifier] = subreport;
        }
        return subreport;
    }
}

#pragma mark JSON serialization

- (NSDictionary *)timeMeasurementsDictionary
{
    @synchronized(self.timeMeasurements) {
        NSMutableDictionary<NSString *, id> *dictionary = [NSMutableDictionary dictionary];
        [self.timeMeasurements enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGTimeMeasurement * _Nonnull timeMeasurement, BOOL * _Nonnull stop) {
            dictionary[key] = @(round(timeMeasurement.timeInterval * 1000.));
        }];
        return dictionary;
    }
}

- (NSDictionary *)JSONDictionary
{
    NSMutableDictionary *dictionary = [self.values mutableCopy];
    [dictionary addEntriesFromDictionary:[self timeMeasurementsDictionary]];
    [self.subreports enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGDiagnosticReport * _Nonnull subreport, BOOL * _Nonnull stop) {
        dictionary[key] = [subreport JSONDictionary];
    }];
    return [dictionary copy];
}

- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:[self JSONDictionary] options:0 error:NULL];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; values = %@; timeMeasurements = %@; subreports: %@>",
            [self class],
            self,
            self.values,
            self.timeMeasurements,
            self.subreports];
}

@end
