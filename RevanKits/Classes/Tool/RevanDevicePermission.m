//
//  RevanDevicePermission.m
//  AFNetworking
//
//  Created by RevanWang on 2018/10/26.
//

#import "RevanDevicePermission.h"
#import <Photos/Photos.h>

@interface RevanDevicePermission ()

@end

@implementation RevanDevicePermission

+ (instancetype)shareInstance {
    static RevanDevicePermission *_shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}

/**
 设备相册权限
 
 @param photoAccess 回调
 */
+ (void)revan_photoAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))photoAccess {
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
        if (photoAccess) {
            photoAccess(NO);
        }
    }
    else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        [self deniedStatusTitle:@"相册" appName:appName];
        if (photoAccess) {
            photoAccess(NO);
        }
    }
    else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        if (photoAccess) {
            photoAccess(YES);
        }
    }
    else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 放一些使用相册的代码
                    if (photoAccess) {
                        photoAccess(YES);
                    }
                });
            }
        }];
    }
}

/**
 设备相机权限
 
 @param videoAccess 回调
 */
+ (void)revan_videoAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))videoAccess {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (videoAccess) {
                            videoAccess(YES);
                        }
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                }
                else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (videoAccess) {
                videoAccess(YES);
            }
        }
        else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            [self deniedStatusTitle:@"相机" appName:appName];
            if (videoAccess) {
                videoAccess(NO);
            }
        }
        else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
            if (videoAccess) {
                videoAccess(NO);
            }
        }
    }
    else {
        [self notDevice];
    }
}


/**
 设备麦克风权限
 
 @param audioAccess 回调
 */
+ (void)revan_audioAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))audioAccess {
    // 1、 获取麦克风设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (audioAccess) {
                            audioAccess(YES);
                        }
                    });
                    // 用户第一次同意了访问麦克风权限
                    NSLog(@"用户第一次同意了麦克风权限 - - %@", [NSThread currentThread]);
                }
                else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了麦克风权限 - - %@", [NSThread currentThread]);
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问麦克风
            if (audioAccess) {
                audioAccess(YES);
            }
        }
        else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问麦克风
            [self deniedStatusTitle:@"麦克风" appName:appName];
            if (audioAccess) {
                audioAccess(NO);
            }
        }
        else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问麦克风");
            if (audioAccess) {
                audioAccess(NO);
            }
        }
    }
    else {
        [self notDevice];
    }
}

/**
 取消权限提示
 
 @param title 什么权限
 @param appName APP名称
 */
+ (void)deniedStatusTitle:(NSString *)title appName:(NSString *)appName {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请去-> [设置 - 隐私 - %@ - %@] 打开访问开关", title, appName] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *gotoAlert = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertVC addAction:cancelAlert];
    [alertVC addAction:gotoAlert];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+ (void)notDevice {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的硬件设备" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertVC addAction:cancelAlert];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


/**
 打电话
 
 @param phoneNumber 电话号码
 */
+ (void)revan_callPhoneNumber:(NSString *)phoneNumber {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:callWebview];
}

@end

