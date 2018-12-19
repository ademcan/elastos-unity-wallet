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
    
    //  const std::string rootPath = "/Users/abilican/Documents/projects/perso/elastos/test-demo-rn-app-from-scratch/test/ios/Data";
    //  const std::string rootPath = "./Data";
    NSString *mRootPath;
    mRootPath = [RNElastosMainchain getRootPath];
    const char *rootPath = [mRootPath UTF8String];
    
    try {
        
        
        // MasterWalletManager
        NSLog(@"Creating MasterWallet");
        Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);
        if (manager == nullptr) {
            // fail process
            NSLog(@"MasterWallet FAILED...");
        }
        
        NSLog(@"MasterWallet DONE...");
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
                    
                } catch (...) {
                    // exception process
                }
                
                
            } else {
                for (size_t i = 0; i < masterWallets.size(); ++i) {
                    std::vector<Elastos::ElaWallet::ISubWallet *> subWallets = masterWallets[i]->GetAllSubWallets();
                    // see transaction operation below
                }
            }
        } catch (...) {
            // exception process
            
        }
        
        
        
    } catch (const std::exception &e) {
        NSLog(@"Exception : %s", e.what());
        NSLog(@"MasterWallet EXCEPTION...");
        // exception process
    }
    
    
    // TODO: Implement
    callback(@[[NSNull null], @"Hello from react-native-elastos-mainchain plugin" ]);
}




//- (dispatch_queue_t)methodQueue
//{
//    return dispatch_get_main_queue();
//}
//
//RCT_EXPORT_METHOD(sayHello: (RCTResponseSenderBlock)callback)
//{
//    // TODO: Implement
//    callback(@[[NSNull null], @"Hello from react-native-elastos-mainchain plugin" ]);
//}

//RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
//{
//    char* mnemonic = generateMnemonic("english", "");
//    callback(@[[NSNull null], @(mnemonic) ]);
//}
//
//RCT_EXPORT_METHOD(getSinglePrivateKey: (RCTResponseSenderBlock)callback)
//{
//    char* mnemonic = generateMnemonic("english", "");
//    void* seed;
//    int seedLen = getSeedFromMnemonic(&seed, mnemonic, "english", "", "");
//    char* privateKey = getSinglePrivateKey(seed, seedLen);
//    callback(@[[NSNull null], @(privateKey) ]);
//}
//
//RCT_EXPORT_METHOD(getSinglePublicKey: (RCTResponseSenderBlock)callback)
//{
//    char* mnemonic = generateMnemonic("english", "");
//    void* seed;
//    int seedLen = getSeedFromMnemonic(&seed, mnemonic, "english", "", "");
//    char* publicKey = getSinglePublicKey(seed, seedLen);
//    callback(@[[NSNull null], @(publicKey) ]);
//}


@end
