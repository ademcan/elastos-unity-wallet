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
#include "IMasterWallet.h"


@implementation RNElastosMainchain

RCT_EXPORT_MODULE()

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
                    
                    NSLog(@" MNEMONIC : %s", mnemonic.c_str() );
                    callback(@[[NSNull null], @(mnemonic.c_str()) ]);
                    
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
