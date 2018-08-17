//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDiagnosticReport.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGDiagnosticsService : NSObject

+ (SRGDiagnosticsService *)sharedService;

- (SRGDiagnosticReport *)reportWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
