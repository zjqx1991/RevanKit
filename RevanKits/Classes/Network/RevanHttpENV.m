//
//  RevanHttpENV.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "RevanHttpENV.h"

@implementation RevanHttpENV

+ (RevanHttpENV *)sharedHttpEnv {
    static RevanHttpENV *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *)baseAPIUrl {
    if (self.networkEnv == RevanAppEnvRelease) {
        return [NSString stringWithFormat:@"%@%@", self.releaseHTTPS, self.baseServerDomain];
    }
    return [NSString stringWithFormat:@"%@%@", self.debugHTTPS, self.baseServerDomain];
}

- (NSString *)baseServerDomain {
    if (self.app == RevanAppMY) {
        return [self valueWithEnvPre:self.debugDomain release:self.releaseDomain];
    }
    return @"";
}

- (NSString *)valueWithEnvPre: (NSString *)pre release:(NSString *)release {
    if (self.networkEnv == RevanAppEnvPre) {
        return pre;
    }
    return release;
}

@end
