//#import "RNElastosMainchain.h"
//#import <Foundation/Foundation.h>
//#import <React/RCTLog.h>
//
//// for cpp lib
//#include <iostream>
//#include <boost/scoped_ptr.hpp>
//#include "MasterWalletManager.h"

#import "RNElastosMainchain.h"
#import <React/RCTLog.h>
#import <Foundation/Foundation.h>

#include <iostream>
#include <boost/scoped_ptr.hpp>
#include "MasterWalletManager.h"
#include "ISubWalletCallback.h"
#include "IMasterWallet.h"

//NSString *language = @"english";
//NSString *mRootPath = [RNElastosMainchain getRootPath];
//const char *rootPath = [mRootPath UTF8String];
//Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);

@implementation RNElastosMainchain


RCT_EXPORT_MODULE()


class SubWalletCallback: public Elastos::ElaWallet::ISubWalletCallback {
public:
    ~SubWalletCallback() {}
    SubWalletCallback() {}
    
    virtual void OnTransactionStatusChanged(
                                            const std::string &txid,const std::string &status,
                                            const nlohmann::json &desc,uint32_t confirms) {
        std::cout << "OnTransactionStatusChanged -> " << std::endl;
    }
    virtual void OnBlockSyncStarted() {
        std::cout << "OnBlockSyncStarted" << std::endl;
    }
    virtual void OnBlockHeightIncreased(uint32_t currentBlockHeight,
                                        uint32_t estimatedHeight) {
        std::cout << "OnBlockHeightIncreased -> " << std::endl;
    }
    virtual void OnBlockSyncStopped() {
        std::cout << "OnBlockSyncStopped" << std::endl;
    }
    virtual void OnBalanceChanged(uint64_t balance) {
        std::cout << "OnBalanceChanged -> " << std::endl;
    }
    virtual void OnTxPublished(const std::string &hash,
                               const nlohmann::json &result) {
        std::cout << "OnTxPublished -> " << std::endl;
    }
    
    virtual void OnTxDeleted(const std::string &hash, bool notifyUser,
                             bool recommendRescan) {
        std::cout << "OnTxDeleted -> " << std::endl;
    }
};



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


RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    
}



RCT_EXPORT_METHOD(importWalletWithMnemonic: (RCTResponseSenderBlock)callback)
{
    
    NSString *mRootPath = [RNElastosMainchain getRootPath];
    const char *rootPath = [mRootPath UTF8String];
    Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);
    
    Elastos::ElaWallet::IMasterWallet *masterWallet = manager->ImportWalletWithMnemonic("masterWalletId", "maximum farm someone leg music federal pyramid lounge scrap bomb skin mystery", "", "Ela-TestRN", false);
    std::string chainID = "ELA";
    Elastos::ElaWallet::ISubWallet *subWallet = masterWallet->CreateSubWallet(chainID,10000);
    std::string publicAddress = subWallet->CreateAddress();
    uint64_t balance = subWallet->GetBalanceWithAddress("EJgzTf95R81xMjQgzLWuUvc8wUwa6kWe2v");
    NSLog(@"BALANCE IS : %@", [NSNumber numberWithUnsignedLongLong:balance]);
    
    while (true) {
        sleep(10);
        NSLog(@"BALANCE IS : %@", [NSNumber numberWithUnsignedLongLong:balance]);
    }
    
    //    Elastos::ElaWallet::ISubWalletCallback *subCallback = new Elastos::ElaWallet::ISubWalletCallback();
    //    [Elastos::ElaWallet::ISubWalletCallback->OnBlockSyncStarted()]
    
    subWallet->AddCallback(new SubWalletCallback());
    
    callback(@[[NSNull null], @"success", @(publicAddress.c_str()), [NSNumber numberWithUnsignedLongLong:balance] ]);
}






RCT_EXPORT_METHOD(getLatestTx: (RCTResponseSenderBlock)callback)
{
    NSString *language = @"english";
    NSString *mRootPath = [RNElastosMainchain getRootPath];
    const char *rootPath = [mRootPath UTF8String];
    Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);
    
    Elastos::ElaWallet::IMasterWallet *masterWallet = manager->ImportWalletWithMnemonic("masterWalletId", "maximum farm someone leg music federal pyramid lounge scrap bomb skin mystery", "", "Ela-TestRN", false);
    std::string chainID = "ELA";
    Elastos::ElaWallet::ISubWallet *subWallet = masterWallet->CreateSubWallet(chainID, 10000);
    std::string publicAddress = subWallet->CreateAddress();
    uint64_t balance = subWallet->GetBalance();
    
    nlohmann::json j = subWallet->GetAllAddress(0, 3);
    
}




RCT_EXPORT_METHOD(createWallet: (RCTResponseSenderBlock)callback)
{
    NSString *mRootPath;
    mRootPath = [RNElastosMainchain getRootPath];
    const char *rootPath = [mRootPath UTF8String];
    
    try {
        // MasterWalletManager
        NSLog(@"Creating MasterWallet");
        Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);
        if (manager == nullptr) {
            // fail process
            NSLog(@"MasterWalletManager FAILED...");
        }
        try {
            std::vector<Elastos::ElaWallet::IMasterWallet *> masterWallets = manager->GetAllMasterWallets();
            if (masterWallets.size() == 0) {
                const std::string walletID = "HDWalletID";
                const std::string phrasePassword = "";
                const std::string payPassword = "Pay_Password~123^456";
                const bool singleAddress = false;
                try {
                    const std::string mnemonic = manager->GenerateMnemonic("english");
                    Elastos::ElaWallet::IMasterWallet *masterWallet = manager->CreateMasterWallet(walletID, mnemonic, phrasePassword, payPassword, singleAddress);
                    
                    std::string chainID = "ELA";
                    Elastos::ElaWallet::ISubWallet *subWallet = masterWallet->CreateSubWallet(chainID, 10000);
                    std::string publicAddress = subWallet->CreateAddress();
                    
                    
                    callback(@[[NSNull null], @(mnemonic.c_str()), @(publicAddress.c_str()) ]);
                    
                } catch (const std::exception &e) {
                    NSLog(@"Mnemonic Exception : %s", e.what());
                }
            } else {
                for (size_t i = 0; i < masterWallets.size(); ++i) {
                    std::vector<Elastos::ElaWallet::ISubWallet *> subWallets = masterWallets[i]->GetAllSubWallets();
                }
            }
        } catch (const std::exception &e) {
            NSLog(@"IMasterWallet Exception : %s", e.what());
        }
    } catch (const std::exception &e) {
        NSLog(@"MasterWalletManager Exception : %s", e.what());
    }
}

@end

