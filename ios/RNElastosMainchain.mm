#import "RNElastosMainchain.h"
#import <React/RCTLog.h>
#import <Foundation/Foundation.h>

//#include <iostream>
//#include <boost/scoped_ptr.hpp>
#include "MasterWalletManager.h"
#include "ISubWalletCallback.h"
#include "IMasterWallet.h"
//#include "nlohmann/json.hpp"
//#include <spdlog/logger.h>
//#include <spdlog/spdlog.h>

@implementation RNElastosMainchain

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sayHi: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    NSLog(@"GenerateMnemonic");
    Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager("");
    const std::string mnemonic = manager->GenerateMnemonic("english");
    callback(@[[NSNull null], @(mnemonic.c_str()) ]);
}

@end
