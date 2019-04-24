//
//  UIViewController+RevanVC.h
//  AFNetworking
//
//  Created by Revan on 2018/8/6.
//

#import <UIKit/UIKit.h>

// 适配iOS11
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(0)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


typedef NS_ENUM(NSInteger, RevanLoadingState) {
    RevanLoadingStateDefault = 0,
    RevanLoadingStateLoading = 1,
    RevanLoadingStateFailed,
    RevanLoadingStateEmpty,
};

@class RevanDataModel;


@protocol RevanLoadingViewProtocol <NSObject>

@property (assign, nonatomic) RevanLoadingState state;

@end


@interface UIViewController (RevanVC)

#pragma mark - 动态关联属性
/** 是否是RevanVC */
@property (nonatomic, assign) BOOL Revan_IsRevanController;
/** 是否隐藏导航栏 */
@property (nonatomic, assign) BOOL Revan_IsNavBarHide;
/** 是否导航栏透明 */
@property (nonatomic, assign) BOOL Revan_IsNavBarAlpha;
/** 是否需要下拉刷新 */
@property (nonatomic, assign) BOOL Revan_NeedPullRefesh;
/** 是否需要上拉加载更多 */
@property (nonatomic, assign) BOOL Revan_NeedLoadMore;
/** 是否显示加载信息 */
@property (nonatomic, assign) BOOL Revan_IsShowLoadingInfo;
/** 显示close按钮 */
@property (nonatomic, assign) BOOL Revan_ShowCloseButton;
//页面disappear时是否停止timer,YES会停止,默认NO
@property (nonatomic, assign) BOOL Revan_IsTimerAllowSelfLive;
/** 网络加载状态 */
@property (nonatomic, strong) UIView<RevanLoadingViewProtocol> *Revan_LoadingInfoView;
/** 请求数据模型 */
@property (nonatomic, strong) RevanDataModel *Revan_DataModel;
/** 初始化数据 */
@property (nonatomic, strong) id Revan_InitData;


#pragma mark - Public Method

/**
 声明UIScrollView
 */
- (UIScrollView *)revan_InnerScrollView;

/**
 声明请求数据的Model-Class
 (需要子类重写)
 */
- (Class)revan_DataModelClass;

/**
 声明Cell-Class
 (需要子类重写)
 */
- (Class)revan_CellClass;
/**
 通用初始化
 */
- (void)revan_CommonInit;

/**
 dealloc
 */
- (void)revan_CommonDealloc;

/**
 加载Model
 */
- (void)revan_LoadDataModel;

/**
 销毁Model
 */
- (void)revan_UnloadDataModel;

/**
 开始加载数据
 */
- (void)revan_StartAsyncFetchData;


/**
 显示和刷新网络状态

 @param state 网络状态
 */
- (void)revan_ShowInfoView:(RevanLoadingState)state;


/**
 创建控制器实例
 */
+ (instancetype)revan_createInstance;
/**
 sb名称
 */
+ (NSString *)revan_storyboardName;


// 对table 或者 collectview 操作
- (void)revan_adjustScrollView:(UIScrollView *)scrollView;
- (void)revan_adjustTableView:(UITableView *)table;
- (void)revan_adjustCollectionView:(UICollectionView *)collect;

- (void)revan_DataChanged;
- (void)revan_DataUploadedWithErrorCode:(int)aErrorCode;
- (void)revan_DataFecthedSuccess:(BOOL)aSuccess;
- (void)revan_DataDeletedSucessess:(BOOL)aSuccess;
- (void)revan_DataHttpApiResult:(NSDictionary *)result;


// 原Swizzing的方法
- (void)revan_ViewDidLoad;
- (void)revan_ViewWillAppear:(BOOL)animated;
- (void)revan_ViewWillDisappear:(BOOL)animated;
- (void)revan_ViewDidDisappear:(BOOL)animated;
- (void)revan_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;



@end
