//
//  RevanDataModel.m
//  Pods
//
//  Created by Revan on 2018/8/7.
//

#import "RevanDataModel.h"

/** 用户id */
static long long sRevanUserId_ = 0;
/** 匿名用户的id */
static int sRevanAnonymousUserId_ = -1;
/** 数据缓存 */
static NSMutableDictionary *sRevanDataModelPool_ = nil;

/** 数据请求的 KEY */
NSString* const kRevanDataSourceKEY = @"dataSource";
/** 获取数据结果的 KEY */
NSString* const kRevanDataFetchResultKEY = @"dataFetchResult";
/** 上传数据请求结果的 KEY */
NSString* const kRevanDataUploadResultKEY = @"dataUploadResult";
/** 删除数据请求结果的 KEY */
NSString* const kRevanDataDeleteResultKEY = @"dataDeleteResult";
/** 需要知道具体api响应的 KEY */
NSString* const kRevanDataAPIResponseKEY = @"apiResponse";




@interface RevanDataModel () {
    NSString *_RevanModel_identify;   //模型的标识
    long long _RevanModel_userid;     //模型的用户标识
}

@property (nonatomic, assign) NSInteger listInstanceCount;
@end



@implementation RevanDataModel

#pragma mark - 用户缓存绑定用户
/**
 初始化 / 更新 用户信息
 
 @param userId 用户标识(userId)
 */
+ (void)revan_initOrUpDateWithUserId:(long long)userId {
    if (userId <= 0) {
        [self clearUserData:userId];
    }
    sRevanUserId_ = userId;
}

/**
 清除用户数据

 @param userId 用户标识
 */
+ (void)clearUserData:(long long)userId {
    [sRevanDataModelPool_ removeObjectForKey:@(userId)];
}

#pragma mark - 创建一个匿名的实例
/**
 创建匿名的model的实例
 */
+ (instancetype)revan_createAnonymousInstance {
    //匿名model使用 类名作为标识符
    return [self revan_createAnonymousInstanceWithIdentify:NSStringFromClass([self class])];
}

/**
 创建匿名的model的实例
 
 @param identify 标识
 */
+ (instancetype)revan_createAnonymousInstanceWithIdentify:(NSString *)identify {
    return [self createInstanceWithIdentify:identify
                                     userId:sRevanAnonymousUserId_];
}

#pragma mark - 创建用户实例
/**
 创建一个关联用户的 model的实例
 */
+ (instancetype)revan_createUserInstance {
    return [self createInstanceWithIdentify:NSStringFromClass([self class])
                                     userId:sRevanUserId_];
}

/**
 创建一个关联用户的 model的实例
 
 @param identify 标识
 */
+ (instancetype)revan_createUserInstanceWithIdentify:(NSString *)identify {
    return [self createInstanceWithIdentify:identify
                                     userId:sRevanUserId_];
}


/**
 销毁实例
 */
- (void)revan_destroyListModelInstance {
//    NSLog(@"%@ destroy", self.class);
    if (self.listInstanceCount > 1) {
        self.listInstanceCount = self.listInstanceCount-1;
    }
    else {
        //获取用户关联的 字典
        NSMutableDictionary *userPool = [sRevanDataModelPool_ objectForKey:@(_RevanModel_userid)];
        //当前类关联的 字典
        NSString *poolKey = NSStringFromClass([self class]);
        NSMutableDictionary *pool = [userPool objectForKey:poolKey];
        //移除当期identify对应的 实例对象
        [pool removeObjectForKey:_RevanModel_identify];
    }
}

/**
 创建一个实例对象
 
 @param identify 对象标识(类字符串/用户Id)
 @param userId   对象关联用户标识
 
 sRevanDataModelPool_ //数据缓冲池
    userId:userPool                 //用户关联的 字典
        classKey:classPool          //当前类对象关联的 字典
            identify:dataModel      //identify关联的类对象
 
 */
+ (instancetype)createInstanceWithIdentify:(NSString *)identify userId:(long long)userId {
    if ([identify isKindOfClass:[NSString class]] == NO) {
        NSAssert(0, @"createInstanceWithIdentify error");
    }
    
    // 初始化 总的数据模型池
    if (sRevanDataModelPool_ == nil) {
        sRevanDataModelPool_ = [[NSMutableDictionary alloc] init];
    }
    
    // 初始化 用户数据模型池
    NSMutableDictionary *userPool = [sRevanDataModelPool_ objectForKey:@(userId)];
    if (userPool == nil) {
        userPool = [[NSMutableDictionary alloc] init];
        [sRevanDataModelPool_ setObject:userPool forKey:@(userId)];
    }
    
    // 初始化 类别数据模型池
    NSString *classKey = NSStringFromClass([self class]);
    NSMutableDictionary *classPool = [userPool objectForKey:classKey];
    if (classPool == nil) {
        classPool = [[NSMutableDictionary alloc] init];
        [userPool setObject:classPool forKey:classKey];
    }
    
    // 初始化 具体的数据模型
    RevanDataModel *dataModel = [classPool objectForKey:identify];
    if (dataModel == nil) {
        // 创建一个带有标识和用户标识的 model
        dataModel = [[[self class] alloc] initWithIdentify:identify
                                                    userid:userId];
        [classPool setObject:dataModel forKey:identify];
    }
    
    dataModel.listInstanceCount = dataModel.listInstanceCount + 1;
    
//    NSLog(@"%@ create", self.class);
    
    return dataModel;
}

/**
 初始化模型对象
 
 @param identify 普通标识
 @param userId  用户标识
 */
- (instancetype)initWithIdentify:(NSString *)identify userid:(long long)userId {
    self = [self init];
    if (self) {
        _RevanModel_identify = identify;
        _RevanModel_userid = userId;
    }
    return self;
}


+ (instancetype)revan_sharedAnonymousInstance {
    return [self sharedInstanceWithIdentify:NSStringFromClass([self class])
                                     userId:sRevanAnonymousUserId_];
}
+ (instancetype)revan_sharedAnonymousInstanceWithIdentify:(NSString *)identify {
    return [self sharedInstanceWithIdentify:identify
                                     userId:sRevanAnonymousUserId_];
}
+ (instancetype)revan_sharedUserInstance {
    return [self sharedInstanceWithIdentify:NSStringFromClass([self class]) userId:sRevanUserId_];
}

+ (instancetype)revan_sharedUserInstanceWithIdentify:(NSString *)identify {
    return [self sharedInstanceWithIdentify:identify userId:sRevanUserId_];
}

+ (instancetype)sharedInstanceWithIdentify:(NSString *)aIdentify userId:(long long)aUserId {
    NSMutableDictionary *userPool = [sRevanDataModelPool_ objectForKey:@(aUserId)];
    if (userPool != nil) {
        NSString *poolKey = NSStringFromClass([self class]);
        NSMutableDictionary *pool = [userPool objectForKey:poolKey];
        if (pool != nil) {
            RevanDataModel *listMode = [pool objectForKey:aIdentify];
            return listMode;
        }
    }
    return nil;
}

#pragma mark - 子类重写 overwrite
/**
 创建模型
 
 @param data 创建模型传入的参数
 @return 实例化的模型
 */
+ (instancetype)revan_createWithInitData:(id)data {
    return [self revan_createUserInstance];
}

/**
 获取数据
 */
- (void)revan_fetchData {
    
}

/**
 刷新数据
 */
- (void)revan_refreshData {
    [self revan_fetchData];
}

/**
 获取更多数据
 */
- (void)revan_fetchMore {
    
}

/**
 上传数据
 
 @param data 数据
 */
- (void)revan_uploadData:(id)data {
    
}

/**
 删除数据
 
 @param data 数据
 */
- (void)revan_deleteData:(id)data {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if (key == kRevanDataSourceKEY) {
        _dataFetched = YES;
    }
}

@end
