#import "RNElastosMainchain.h"
#import "Elastos.Wallet.Utility.h"
#import <Foundation/Foundation.h>
#import <React/RCTLog.h>

@implementation RNElastosMainchain

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement
}

RCT_EXPORT_METHOD(sayHello: (RCTResponseSenderBlock)callback)
{
    // TODO: Implement
    callback(@[[NSNull null], @"Hello from react-native-elastos-mainchain plugin" ]);
}


RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    // TODO: Implement
    char* mnemonic = generateMnemonic("english", "");
    callback(@[[NSNull null], @(mnemonic) ]);
}


@end
