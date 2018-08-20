//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticsService.h"

#import "SRGDiagnosticReport+Private.h"

static NSMutableDictionary<NSString *, SRGDiagnosticsService *> *s_diagnosticsServices;

@interface SRGDiagnosticsService ()

@property (nonatomic, copy) void (^submissionBlock)(NSDictionary *JSONDictionary, void (^completionBlock)(BOOL success));

@property (nonatomic) NSMutableDictionary<NSString *, SRGDiagnosticReport *> *reports;
@property (nonatomic) NSMutableArray<SRGDiagnosticReport *> *pendingReports;

@property (nonatomic) NSTimer *timer;
@property (nonatomic, getter=isSubmitting) BOOL submitting;

@end

@implementation SRGDiagnosticsService

#pragma mark Class methods

+ (void)registerServiceWithName:(NSString *)name submissionBlock:(void (^)(NSDictionary * _Nonnull, void (^ _Nonnull)(BOOL)))submissionBlock
{
    @synchronized(s_diagnosticsServices) {
        static dispatch_once_t s_onceToken;
        dispatch_once(&s_onceToken, ^{
            s_diagnosticsServices = [NSMutableDictionary dictionary];
        });
        
        SRGDiagnosticsService *diagnosticsService = s_diagnosticsServices[name];
        if (! diagnosticsService) {
            diagnosticsService = [[SRGDiagnosticsService alloc] init];
            s_diagnosticsServices[name] = diagnosticsService;
        }
        diagnosticsService.submissionBlock = submissionBlock;
    }
}

+ (SRGDiagnosticsService *)serviceWithName:(NSString *)name
{
    @synchronized(s_diagnosticsServices) {
        return s_diagnosticsServices[name];
    }
}

#pragma mark Object lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        self.reports = [NSMutableDictionary dictionary];
        self.pendingReports = [NSMutableArray array];
        
        // FIXME: Avoid retain cycle (if service is replaced with another service for the same name, deallocation must correctly
        //        occur)
        self.timer = [NSTimer timerWithTimeInterval:30. target:self selector:@selector(submitPendingReports:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark Getters and setters

- (void)setTimer:(NSTimer *)timer
{
    [_timer invalidate];
    _timer = timer;
}

#pragma mark Reports

- (SRGDiagnosticReport *)reportWithName:(NSString *)name
{
    @synchronized(self) {
        SRGDiagnosticReport *report = self.reports[name];
        if (! report) {
            report = [[SRGDiagnosticReport alloc] initWithDiagnosticsService:self];
            self.reports[name] = report;
        }
        return report;
    }
}

#pragma mark Submission

- (void)prepareToSubmitReport:(SRGDiagnosticReport *)report
{
    @synchronized(self) {
        NSString *identifier = [self.reports allKeysForObject:report].firstObject;
        if (identifier) {
            [self.reports removeObjectForKey:identifier];
            [self.pendingReports addObject:[report copy]];
        }
    }
}

- (void)submitPendingReports
{
    @synchronized(self) {
        if (self.submitting) {
            return;
        }
        
        self.submitting = YES;
        
        __block NSUInteger processedReports = 0;
        NSArray<SRGDiagnosticReport *> *pendingReports = [self.pendingReports copy];
        for (SRGDiagnosticReport *report in pendingReports) {
            self.submissionBlock([report JSONDictionary], ^(BOOL success) {
                @synchronized(self) {
                    if (success) {
                        [self.pendingReports removeObject:report];
                    }
                    
                    ++processedReports;
                    if (processedReports == pendingReports.count) {
                        self.submitting = NO;
                    }
                }
            });
        }
    }
}

#pragma mark Timers

- (void)submitPendingReports:(NSTimer *)timer
{
    [self submitPendingReports];
}

@end
