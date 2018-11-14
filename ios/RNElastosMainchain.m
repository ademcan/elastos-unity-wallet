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

//RCT_EXPORT_METHOD(sayHello: (RCTResponseSenderBlock)callback)
//{
//    // TODO: Implement
//    callback(@[[NSNull null], @"Hello from react-native-elastos-mainchain plugin" ]);
//}

RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    char* mnemonic = generateMnemonic("english", "");
    callback(@[[NSNull null], @(mnemonic) ]);
}

RCT_EXPORT_METHOD(getSinglePrivateKey: (RCTResponseSenderBlock)callback)
{
    char* mnemonic = generateMnemonic("english", "");
    void* seed;
    int seedLen = getSeedFromMnemonic(&seed, mnemonic, "english", "", "");
    char* privateKey = getSinglePrivateKey(seed, seedLen);
    callback(@[[NSNull null], @(privateKey) ]);
}

RCT_EXPORT_METHOD(getSinglePublicKey: (RCTResponseSenderBlock)callback)
{
    char* mnemonic = generateMnemonic("english", "");
    void* seed;
    int seedLen = getSeedFromMnemonic(&seed, mnemonic, "english", "", "");
    char* publicKey = getSinglePublicKey(seed, seedLen);
    callback(@[[NSNull null], @(publicKey) ]);
}


@end
