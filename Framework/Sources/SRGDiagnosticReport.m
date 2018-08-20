//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

#import "SRGDiagnosticsService.h"
#import "SRGDiagnosticsService+Private.h"
#import "SRGTimeMeasurement.h"

@interface SRGDiagnosticReport ()

@property (nonatomic, weak) SRGDiagnosticsService *diagnosticsService;

@property (nonatomic) NSMutableDictionary<NSString *, id> *values;
@property (nonatomic) NSMutableDictionary<NSString *, SRGTimeMeasurement *> *timeMeasurements;
@property (nonatomic) NSMutableDictionary<NSString *, SRGDiagnosticReport *> *subreports;

@end

@implementation SRGDiagnosticReport

#pragma mark Object lifecycle

- (instancetype)initWithDiagnosticsService:(SRGDiagnosticsService *)diagnosticsService;
{
    if (self = [super init]) {
        self.diagnosticsService = diagnosticsService;
        self.values = [NSMutableDictionary dictionary];
        self.timeMeasurements = [NSMutableDictionary dictionary];
        self.subreports = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (instancetype)init
{
    return [self initWithDiagnosticsService:nil];
}

#pragma clang diagnostic pop

#pragma mark Report data

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

- (SRGDiagnosticReport *)subreportForKey:(NSString *)key
{
    @synchronized(self) {
        SRGDiagnosticReport *subreport = self.subreports[key];
        if (! subreport) {
            subreport = [[SRGDiagnosticReport alloc] initWithDiagnosticsService:nil];
            self.subreports[key] = subreport;
        }
        return subreport;
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

- (NSDictionary *)JSONDictionary
{
    @synchronized(self) {
        NSMutableDictionary *dictionary = [self.values mutableCopy];
        [dictionary addEntriesFromDictionary:[self timeMeasurementsDictionary]];
        [self.subreports enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGDiagnosticReport * _Nonnull subreport, BOOL * _Nonnull stop) {
            dictionary[key] = [subreport JSONDictionary];
        }];
        return [dictionary copy];
    }
}

#pragma mark Submission

- (void)submit
{
    [self.diagnosticsService submitReport:self];
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    SRGDiagnosticReport *diagnosticReport = [[SRGDiagnosticReport alloc] initWithDiagnosticsService:self.diagnosticsService];
    diagnosticReport.values = [self.values mutableCopy];
    diagnosticReport.timeMeasurements = [self.timeMeasurements mutableCopy];
    
    NSMutableDictionary<NSString *, SRGDiagnosticReport *> *subreports = [NSMutableDictionary dictionary];
    [diagnosticReport.subreports enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SRGDiagnosticReport * _Nonnull subreport, BOOL * _Nonnull stop) {
        subreports[key] = [subreport copy];
    }];
    diagnosticReport.subreports = subreports;
    return diagnosticReport;
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
