#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <Foundation/Foundation.h>

@interface RNElastosMainchain : NSObject <RCTBridgeModule>

@end
