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

// Functions required to load the /Data folder properly
+ (NSString *)getRootPath
{
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/Data", pathStr];

    NSString *toPathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

    NSString *toPath = [toPathStr stringByAppendingString:@"/Data"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:NO attributes:nil error:nil];
    [self copyFileFromPath:path toPath:toPath];

    return toPath;
}
+ (void)copyFileFromPath:(NSString *)sourcePath toPath:(NSString *)toPath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:sourcePath error:&error];
    if(error) {}
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [sourcePath stringByAppendingPathComponent:[array objectAtIndex:i]];
        NSString *fullToPath = [toPath stringByAppendingPathComponent:[array objectAtIndex:i]];

        BOOL isFolder = NO;
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        if (isExist)
        {
            NSError *err = nil;[[NSFileManager defaultManager] copyItemAtPath:fullPath toPath:fullToPath error:&err];
            if (isFolder){
                [self copyFileFromPath:fullPath toPath:fullToPath];
            }
        }
    }
}


// var
NSString *mRootPath = [RNElastosMainchain getRootPath];
const char *rootPath = [mRootPath UTF8String];
Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);

// BRIDGES

// this is a simple test to check the JavaScript <-> ObjC++ connection
RCT_EXPORT_METHOD(sayHi: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

// *******************
//
// MasterWalletManager
//
// *******************

// SaveConfigs ()
RCT_EXPORT_METHOD(saveConfigs: (RCTResponseSenderBlock)callback)
{
    try{
        manager->SaveConfigs();
        NSLog(@"Hi there...");
    }
    catch (const std::exception &e) {
        NSLog(@"SaveConfigs Exception : %s", e.what());
    }
}

// GenerateMnemonic (const std::string &language)
RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    const std::string mnemonic = manager->GenerateMnemonic("english");
    callback(@[[NSNull null], @(mnemonic.c_str()) ]);
}

// CreateMasterWallet (const std::string &masterWalletId, const std::string &mnemonic, const std::string &phrasePassword, const std::string &payPassword, const std::string &language="english")
RCT_EXPORT_METHOD(createMasterWallet: (std::string *)masterWalletId withMnemomnic:(std::string*)mnemonic withPhrasePassword:(std::string*)phrasePassword withpayPassword:(std::string*)payPassword withLanguage:(std::string*)language callback:(RCTResponseSenderBlock)callback)
{
    Elastos::ElaWallet::IMasterWallet *masterWallet = manager->CreateMasterWallet(*masterWalletId, *mnemonic, *phrasePassword, *payPassword, "english");
}

// CreateMultiSignMasterWallet (const std::string &masterWalletId, const nlohmann::json &coSigners, uint32_t requiredSignCount)
RCT_EXPORT_METHOD(createMultiSignMasterWallet: (std::string* )masterWalletId withCosigners:(nlohmann::json*)coSigners withRequiredSignCount:(uint32_t*)requiredSignCount callback:(RCTResponseSenderBlock)callback)
{
    try{
        Elastos::ElaWallet::IMasterWallet *masterWallet = manager->CreateMultiSignMasterWallet(*masterWalletId, coSigners, *requiredSignCount);
    }
    catch (const std::exception &e) {
        NSLog(@"MasterWallet Exception : %s", e.what());
    }
}

//RCT_EXPORT_METHOD(createMultiSignMasterWallet: (RCTResponseSenderBlock)callback)
//{
//    Elastos::ElaWallet::IMasterWallet = manager->createMultiSignMasterWallet();
//    NSLog(@"Hi there...");
//}

// GetAllMasterWallets () const
RCT_EXPORT_METHOD(getAllMasterWallets: (RCTResponseSenderBlock)callback)
{
    std::vector<Elastos::ElaWallet::IMasterWallet *> masterWallets = manager->GetAllMasterWallets();
}

// DestroyWallet (const std::string &masterWalletId)
RCT_EXPORT_METHOD(destroyWallet:(std::string* )masterWalletId callback:(RCTResponseSenderBlock)callback)
{
    try{
        manager->DestroyWallet(*masterWalletId);
    }
    catch (const std::exception &e) {
        NSLog(@"DestroyWallet Exception : %s", e.what());
    }
}

// ImportWalletWithKeystore (const std::string &masterWalletId, const nlohmann::json &keystoreContent, const std::string &backupPassword, const std::string &payPassword, const std::string &phrasePassword="")
RCT_EXPORT_METHOD(importWalletWithKeystore: (std::string*) masterWalletId withKeystoreContent:(nlohmann::json*)keystoreContent withBackupPassword:(std::string*)backupPassword withPayPassword:(std::string*)payPasword withPhrasePassword:(std::string*)phrasePassword callback:(RCTResponseSenderBlock)callback)
{
    manager->ImportWalletWithKeystore(*masterWalletId, keystoreContent, *backupPassword, *payPasword);
}

// ImportWalletWithMnemonic (const std::string &masterWalletId, const std::string &mnemonic, const std::string &phrasePassword, const std::string &payPassword, const std::string &language="english")
RCT_EXPORT_METHOD(importWalletWithMnemonic: (std::string*)masterWalletId withMnemomnic:(std::string*)mnemonic withPhrasePassword:(std::string*)phrasePassword withpayPassword:(std::string*)payPassword withLanguage:(std::string*)language callback:(RCTResponseSenderBlock)callback)
{
    manager->ImportWalletWithMnemonic(*masterWalletId, *mnemonic, *phrasePassword, *payPassword, "english");
}

// ExportWalletWithKeystore (IMasterWallet *masterWallet, const std::string &backupPassword, const std::string &payPassword)
RCT_EXPORT_METHOD(exportWalletWithKeystore: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

// ExportWalletWithMnemonic (IMasterWallet *masterWallet, const std::string &payPassword)
RCT_EXPORT_METHOD(exportWalletWithMnemonic: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}



// MainchainSuballet

RCT_EXPORT_METHOD(createDepositTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}


// *******************
//
// MasterWallet
//
// *******************

RCT_EXPORT_METHOD(getId: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getBasicInfo: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getAllSubWallets: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(createSubWallet: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(recoverSubWallet: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getPublicKey: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(sign: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(checkSign: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(isAddressValid: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getSupportedChains: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(changePassword: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

// SidechainSubWallet

RCT_EXPORT_METHOD(createWithdrawTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getGenesisAddress: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

// SubWallet

RCT_EXPORT_METHOD(getChainId: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

//RCT_EXPORT_METHOD(getBasicInfo: (RCTResponseSenderBlock)callback)
//{
//    NSLog(@"Hi there...");
//}

RCT_EXPORT_METHOD(getBalanceInfo: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getBalance: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(createAddress: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getAllAddress: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getBalanceWithAddress: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(addCallback: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(removeCallback: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

//RCT_EXPORT_METHOD(createTransaction: (RCTResponseSenderBlock)callback)
//{
//    NSLog(@"Hi there...");
//}

RCT_EXPORT_METHOD(createMultiSignTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(calculateTransactionFee: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(updateTransactionFee: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(signTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(publishTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(getAllTransaction: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

//RCT_EXPORT_METHOD(sign: (RCTResponseSenderBlock)callback)
//{
//    NSLog(@"Hi there...");
//}

//RCT_EXPORT_METHOD(checkSign: (RCTResponseSenderBlock)callback)
//{
//    NSLog(@"Hi there...");
//}

//RCT_EXPORT_METHOD(getPublicKey: (RCTResponseSenderBlock)callback)
//{
//    NSLog(@"Hi there...");
//}



@end
