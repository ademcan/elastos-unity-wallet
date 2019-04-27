#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RNElastosMainchain : NSObject <RCTBridgeModule>
+ (NSString *)getRootPath;
+ (void)copyFileFromPath:(NSString *)sourcePath toPath:(NSString *)toPath;
//- (Elastos::ElaWallet::IMasterWallet *) getIMasterWallet:(std::string)masterWalletID;

@end
