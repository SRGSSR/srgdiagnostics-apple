//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticsService.h"

@interface SRGDiagnosticsService ()

@property (nonatomic) NSMutableDictionary<NSString *, SRGDiagnosticReport *> *reports;

@end

@implementation SRGDiagnosticsService

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.reports = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Reports

- (SRGDiagnosticReport *)reportForIdentifier:(NSString *)identifier
{
    SRGDiagnosticReport *report = self.reports[identifier];
    if (! report) {
        report = [[SRGDiagnosticReport alloc] init];
        self.reports[identifier] = report;
    }
    return report;
}

@end
