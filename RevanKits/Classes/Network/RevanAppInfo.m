//
//  RevanAppInfo.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "RevanAppInfo.h"
#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>
#import "NSString+RevanHttp.h"

static NSString *deviceId = @"DEVICEID";

@implementation RevanAppInfo
#pragma mark - ************** public Method **************
// 设备id
+ (NSString *)revan_deviceId {
    NSString * idfa  = [self loadItem:deviceId];
    if ([idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        idfa = nil;
    }
    if (idfa && [idfa isKindOfClass:[NSString class]] && idfa.length) {
        return idfa;
    }else{
        idfa = [[NSUUID UUID] UUIDString];
        [self saveItem:deviceId data:idfa];
        return idfa;
    }
}

// 广告标识
+ (NSString *)revan_idfa {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return [adId revan_realString];
}

// AppId
+ (NSString *)revan_appId {
    return @"2018052215000937";
}


// bundle
+ (NSString *)revan_appBundle {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [infoDict objectForKey:@"CFBundleIdentifier"];
    return bundleName;
}

// App名称
+ (NSString *)revan_appName {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDict objectForKey:@"CFBundleDisplayName"];
    return name;
}

// 版本号
+ (NSString *)revan_appVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    if (version == nil) {
        version = @"1.0";
    }
    return version;
}

/**
 版本号(三位100)
 */
+ (NSInteger)revan_appVersionNumber {
    NSArray *versionArray = [[RevanAppInfo revan_appVersion] componentsSeparatedByString:@"."];
    NSInteger versionNumber = [versionArray.firstObject integerValue] * 100 + [versionArray[1] integerValue] * 10 + [versionArray.lastObject integerValue];
    if (versionArray.count == 2) {
        versionNumber = [versionArray.firstObject integerValue] * 100 + [versionArray.lastObject integerValue] * 10;
    }
    else if (versionArray.count == 1) {
        versionNumber = [versionArray.firstObject integerValue] * 100;
    }
    return versionNumber;
}

// build号
+ (int)revan_buildVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleVersion"];
    return version.intValue;
}

/**
 systemName
 */
+ (NSString *)revan_systemName {
    static NSString *name = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        name = [UIDevice currentDevice].systemName;
    });
    return name;
}


/**
 systemVersion
 */
+ (NSString *)revan_systemVersion {
    static NSString *version = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion;
    });
    return version;
}

/**
 设备类型
 */
+ (int)deviceType {
    static int type = 2;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *model = [UIDevice currentDevice].model;
        if ([model hasPrefix:@"iPad"]) {
            type = 6;
        }
    });
    return type;
}

/**
 设备型号
 */
+ (NSString *)revan_modelName {
    static NSString *modelName = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        size_t size;
        
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        modelName = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        
        if (modelName.length <= 0)
        {
            modelName = @"unknown";
        }
    });
    
    return modelName;
}

#pragma mark - ************** private Method **************
+ (id)loadItem:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
//            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    CFRelease((__bridge CFDictionaryRef)keychainQuery);
    return ret;
}

+ (void)saveItem:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    CFRelease((__bridge CFDictionaryRef)(keychainQuery));
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    CFRelease((__bridge CFDictionaryRef)(keychainQuery));
}

+ (void)deleteItem:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    CFRelease((__bridge CFDictionaryRef)(keychainQuery));
}

#pragma mark - for keychain
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

@end
