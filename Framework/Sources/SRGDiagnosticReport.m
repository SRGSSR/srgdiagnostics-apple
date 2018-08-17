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
        self.values[key] = @((NSInteger)value);
    }
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @((float)value);
    }
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    @synchronized(self.values) {
        self.values[key] = @((double)value);
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

@end
