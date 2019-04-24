//
//  RevanDataModel.h
//  Pods
//
//  Created by Revan on 2018/8/7.
//

#import <Foundation/Foundation.h>

/** 数据请求的 KEY */
OBJC_EXPORT NSString* const kRevanDataSourceKEY;
/** 获取数据结果的 KEY */
OBJC_EXPORT NSString* const kRevanDataFetchResultKEY;
/** 上传数据请求结果的 KEY */
OBJC_EXPORT NSString* const kRevanDataUploadResultKEY;
/** 删除数据请求结果的 KEY */
OBJC_EXPORT NSString* const kRevanDataDeleteResultKEY;
/** 需要知道具体api响应的 KEY */
OBJC_EXPORT NSString* const kRevanDataAPIResponseKEY;

@interface RevanDataModel : NSObject{
@protected
    BOOL _dataFetched;
    BOOL _hasMore;
    BOOL _emptyData;
}

/**
 *  拥有这个model的vc
 */
@property (nonatomic, weak) UIViewController * ownerVC;

/**
 注册cell
 */
@property (nonatomic, strong) NSString *cellIdentify;

@property (nonatomic, readonly) id dataFetchResult;
@property (nonatomic, readonly) id dataUploadResult;
@property (nonatomic, readonly) id dataDeleteResult;
@property (nonatomic, readonly) id dataSource;

@property (nonatomic, readonly) BOOL dataFetched;
@property (nonatomic, readonly) BOOL hasMore;
@property (nonatomic, readonly) BOOL emptyData;


#pragma mark - 子类重写 overwrite
/**
 创建模型
 
 @param data 创建模型传入的参数
 @return 实例化的模型
 */
+ (instancetype)revan_createWithInitData:(id)data;

/**
 获取数据
 */
- (void)revan_fetchData;

/**
 刷新数据
 */
- (void)revan_refreshData;

/**
 获取更多数据
 */
- (void)revan_fetchMore;

/**
 上传数据
 
 @param data 数据
 */
- (void)revan_uploadData:(id)data;

/**
 删除数据
 
 @param data 数据
 */
- (void)revan_deleteData:(id)data;

#pragma mark - public Method
/**
 初始化 / 更新 用户信息

 @param userId 用户标识(userId)
 */
+ (void)revan_initOrUpDateWithUserId:(long long)userId;

/**
 创建匿名的model的实例
 */
+ (instancetype)revan_createAnonymousInstance;
/**
 创建匿名的model的实例

 @param identify 标识
 */
+ (instancetype)revan_createAnonymousInstanceWithIdentify:(NSString *)identify;


/**
 创建一个关联用户的 model的实例
 */
+ (instancetype)revan_createUserInstance;

/**
 创建一个关联用户的 model的实例

 @param identify 标识
 */
+ (instancetype)revan_createUserInstanceWithIdentify:(NSString *)identify;

/**
 销毁实例
 */
- (void)revan_destroyListModelInstance;


// shared 如果已经存在引用返回当前引用，如果不存在，返回nil
+ (instancetype)revan_sharedAnonymousInstance;
+ (instancetype)revan_sharedAnonymousInstanceWithIdentify:(NSString *)identify;
+ (instancetype)revan_sharedUserInstance;
+ (instancetype)revan_sharedUserInstanceWithIdentify:(NSString *)identify;


@end
