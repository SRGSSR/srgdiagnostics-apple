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

#pragma mark Class methods

+ (SRGDiagnosticsService *)sharedService
{
    static dispatch_once_t s_onceToken;
    static SRGDiagnosticsService *s_sharedService;
    dispatch_once(&s_onceToken, ^{
        s_sharedService = [[SRGDiagnosticsService alloc] init];
    });
    return s_sharedService;
}

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.reports = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Reports

- (SRGDiagnosticReport *)reportWithIdentifier:(NSString *)identifier
{
    @synchronized(self.reports) {
        SRGDiagnosticReport *report = self.reports[identifier];
        if (! report) {
            report = [[SRGDiagnosticReport alloc] init];
            self.reports[identifier] = report;
        }
        return report;
    }
}

@end