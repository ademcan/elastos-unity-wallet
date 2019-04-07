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


RCT_EXPORT_METHOD(sayHi: (RCTResponseSenderBlock)callback)
{
    NSLog(@"Hi there...");
}

RCT_EXPORT_METHOD(generateMnemonic: (RCTResponseSenderBlock)callback)
{
    NSString *mRootPath = [RNElastosMainchain getRootPath];
    const char *rootPath = [mRootPath UTF8String];
    NSLog(@"GenerateMnemonic");
    Elastos::ElaWallet::MasterWalletManager *manager = new Elastos::ElaWallet::MasterWalletManager(rootPath);
    const std::string mnemonic = manager->GenerateMnemonic("english");
    NSLog(@(mnemonic.c_str()));
    callback(@[[NSNull null], @(mnemonic.c_str()) ]);}

@end
