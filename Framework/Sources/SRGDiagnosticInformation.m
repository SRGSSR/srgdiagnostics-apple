//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticInformation.h"

#import "SRGTimeMeasurement.h"

@interface SRGDiagnosticInformation ()

@property (nonatomic) NSMutableDictionary<NSString *, id> *values;
@property (nonatomic) NSMutableDictionary<NSString *, SRGTimeMeasurement *> *timeMeasurements;
@property (nonatomic) NSMutableDictionary<NSString *, SRGDiagnosticInformation *> *informationEntries;

@end

@implementation SRGDiagnosticInformation

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.values = [NSMutableDictionary dictionary];
        self.timeMeasurements = [NSMutableDictionary dictionary];
        self.informationEntries = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Associated data

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = @(value);
    }
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = @(value);
    }
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = @(value);
    }
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = @(value);
    }
}

- (void)setString:(NSString *)string forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = string;
    }
}

- (void)setNumber:(NSNumber *)number forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = number;
    }
}

- (void)setURL:(NSURL *)URL forKey:(NSString *)key
{
    @synchronized(self) {
        self.values[key] = URL.absoluteString;
    }
}

- (void)startTimeMeasurementForKey:(NSString *)key
{
    [[self timeMeasurementForKey:key] start];
}

- (void)stopTimeMeasurementForKey:(NSString *)key
{
    [[self timeMeasurementForKey:key] stop];
}

#pragma mark Time measurements

- (SRGTimeMeasurement *)timeMeasurementForKey:(NSString *)key
{
    @synchronized(self) {
        SRGTimeMeasurement *timeMeasurement = self.timeMeasurements[key];
        if (! timeMeasurement) {
            timeMeasurement = [[SRGTimeMeasurement alloc] init];
            self.timeMeasurements[key] = timeMeasurement;
        }
        return timeMeasurement;
    }
}

- (SRGDiagnosticInformation *)informationForKey:(NSString *)key
{
    @synchronized(self) {
        SRGDiagnosticInformation *information = self.informationEntries[key];
        if (! information) {
            information = [[SRGDiagnosticInformation alloc] init];
            self.informationEntries[key] = information;
        }
        return information;
    }
}

#pragma mark JSON serialization

- (NSDictionary *)timeMeasurementsDictionary
{
    @synchronized(self) {
        NSMutableDictionary<NSString *, id> *dictionary = [NSMutableDictionary dictionary];
        [self.timeMeasurements enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGTimeMeasurement * _Nonnull timeMeasurement, BOOL * _Nonnull stop) {
            NSTimeInterval timeInterval = timeMeasurement.timeInterval;
            if (timeInterval != SRGTimeMeasurementUndefined) {
                dictionary[key] = @(round(timeInterval * 1000.));
            }
        }];
        return dictionary;
    }
}

- (NSDictionary<NSString *,id> *)JSONDictionary
{
    @synchronized(self) {
        NSMutableDictionary *dictionary = [self.values mutableCopy];
        [dictionary addEntriesFromDictionary:[self timeMeasurementsDictionary]];
        [self.informationEntries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGDiagnosticInformation * _Nonnull information, BOOL * _Nonnull stop) {
            dictionary[key] = [information JSONDictionary];
        }];
        return [dictionary copy];
    }
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    @synchronized(self) {
        SRGDiagnosticInformation *information = [[SRGDiagnosticInformation alloc] init];
        information.values = [self.values mutableCopy];
        information.timeMeasurements = [self.timeMeasurements mutableCopy];
        
        NSMutableDictionary<NSString *, SRGDiagnosticInformation *> *informationEntries = [NSMutableDictionary dictionary];
        [self.informationEntries enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGDiagnosticInformation * _Nonnull information, BOOL * _Nonnull stop) {
            informationEntries[key] = [information copy];
        }];
        information.informationEntries = informationEntries;
        return information;
    }
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; values = %@; timeMeasurements = %@; informationEntries: %@>",
            self.class,
            self,
            self.values,
            self.timeMeasurements,
            self.informationEntries];
}

@end
