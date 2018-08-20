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

@end

@implementation SRGDiagnosticReport

#pragma mark Object lifecycle

- (instancetype)initWithDiagnosticsService:(SRGDiagnosticsService *)diagnosticsService;
{
    if (self = [super init]) {
        self.diagnosticsService = diagnosticsService;
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithDiagnosticsService:[SRGDiagnosticsService new]];
}

#pragma clang diagnostic pop

#pragma mark Submission

- (void)submit
{
    [self.diagnosticsService submitReport:self];
}

@end
