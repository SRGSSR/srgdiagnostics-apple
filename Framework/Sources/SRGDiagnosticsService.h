//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: Thread-safety considerations
@interface SRGDiagnosticsService : NSObject

+ (SRGDiagnosticsService *)sharedService;

- (SRGDiagnosticReport *)reportForIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
