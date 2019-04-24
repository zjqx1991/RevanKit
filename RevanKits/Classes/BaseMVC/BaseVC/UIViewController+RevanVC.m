//
//  UIViewController+RevanVC.m
//  AFNetworking
//
//  Created by Revan on 2018/8/6.
//

#import "UIViewController+RevanVC.h"
#import <objc/runtime.h>
#import "RevanDataModel.h"
#import "RevanLoadingInfoView.h"
#import "UIBarButtonItem+AVT.h"
#import "MJRefresh.h"
#import "RevanHttpResponse.h"
#import "UIImage+RevanVC.h"


/** 是否是RevanVC的 KEY */
static const char kRevan_IsRevanControllerKey;
/** 是否隐藏导航栏的 KEY */
static const char kRevan_IsNavBarHideKey;
/** 是否导航栏透明的 KEY */
static const char kRevan_IsNavBarAlphaKey;
/** 是否需要下拉刷新的 KEY */
static const char kRevan_NeedPullRefeshKey;
/** 是否需要上拉加载更多的 KEY */
static const char kRevan_NeedLoadMoreKey;
/** 是否显示加载信息的 KEY */
static const char kRevan_IsShowLoadingInfoKey;
/** 是否显示加载信息的 KEY */
static const char kRevan_ShowCloseButtonKey;
/** 定时器自动刷新请求的 KEY */
static const char kRevan_IsTimerAllowSelfLiveKey;
/** 网络加载状态信息的 KEY */
static const char kRevan_LoadingInfoViewKey;
/** 请求数据模型 */
static const char kRevan_DataModelKey;
/** 初始化数据 */
static const char kRevan_InitDataKey;

/** view加载 */
static const char kRevan_ViewDidLoadKey;
/** view已经显示 */
static const char kRevan_IsViewAppearredKey;



@implementation UIViewController (RevanVC)

#pragma mark - 动态关联属性
/** 是否是RevanVC */
- (void)setRevan_IsRevanController:(BOOL)Revan_IsRevanController {
    objc_setAssociatedObject(self, &kRevan_IsRevanControllerKey, @(Revan_IsRevanController), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsRevanController {
    return [objc_getAssociatedObject(self, &kRevan_IsRevanControllerKey) boolValue];
}

/** 是否隐藏导航栏 */
- (void)setRevan_IsNavBarHide:(BOOL)Revan_IsNavBarHide {
    objc_setAssociatedObject(self, &kRevan_IsNavBarHideKey, @(Revan_IsNavBarHide), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsNavBarHide {
    return [objc_getAssociatedObject(self, &kRevan_IsNavBarHideKey) boolValue];
}

/** 是否导航栏透明 */
- (void)setRevan_IsNavBarAlpha:(BOOL)Revan_IsNavBarAlpha {
    objc_setAssociatedObject(self, &kRevan_IsNavBarAlphaKey, @(Revan_IsNavBarAlpha), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsNavBarAlpha {
    return [objc_getAssociatedObject(self, &kRevan_IsNavBarAlphaKey) boolValue];
}

/** 是否需要下拉刷新 */
- (void)setRevan_NeedPullRefesh:(BOOL)Revan_NeedPullRefesh {
    objc_setAssociatedObject(self, &kRevan_NeedPullRefeshKey, @(Revan_NeedPullRefesh), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_NeedPullRefesh {
    return [objc_getAssociatedObject(self, &kRevan_NeedPullRefeshKey) boolValue];
}

/** 是否需要上拉加载更多 */
- (void)setRevan_NeedLoadMore:(BOOL)Revan_NeedLoadMore {
    objc_setAssociatedObject(self, &kRevan_NeedLoadMoreKey, @(Revan_NeedLoadMore), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_NeedLoadMore {
    return [objc_getAssociatedObject(self, &kRevan_NeedLoadMoreKey) boolValue];
}

/** 是否显示加载信息 */
- (void)setRevan_IsShowLoadingInfo:(BOOL)Revan_IsShowLoadingInfo {
    objc_setAssociatedObject(self, &kRevan_IsShowLoadingInfoKey, @(Revan_IsShowLoadingInfo), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsShowLoadingInfo {
    return [objc_getAssociatedObject(self, &kRevan_IsShowLoadingInfoKey) boolValue];
}

/** 是否显示closeBtn */
- (void)setRevan_ShowCloseButton:(BOOL)Revan_ShowCloseButton {
    objc_setAssociatedObject(self, &kRevan_ShowCloseButtonKey, @(Revan_ShowCloseButton), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_ShowCloseButton {
    return [objc_getAssociatedObject(self, &kRevan_ShowCloseButtonKey) boolValue];
}

//Timer自动刷新
- (void)setRevan_IsTimerAllowSelfLive:(BOOL)Revan_IsTimerAllowSelfLive {
    objc_setAssociatedObject(self, &kRevan_IsTimerAllowSelfLiveKey, @(Revan_IsTimerAllowSelfLive), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsTimerAllowSelfLive {
    return [objc_getAssociatedObject(self, &kRevan_IsTimerAllowSelfLiveKey) boolValue];
}

// 网络请求状态view
- (void)setRevan_LoadingInfoView:(UIView<RevanLoadingViewProtocol> *)Revan_LoadingInfoView {
    objc_setAssociatedObject(self, &kRevan_LoadingInfoViewKey, Revan_LoadingInfoView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView<RevanLoadingViewProtocol> *)Revan_LoadingInfoView {
    return objc_getAssociatedObject(self, &kRevan_LoadingInfoViewKey);
}

/** 请求数据模型 */
- (void)setRevan_DataModel:(RevanDataModel *)Revan_DataModel {
    objc_setAssociatedObject(self, &kRevan_DataModelKey, Revan_DataModel, OBJC_ASSOCIATION_RETAIN);
}

- (RevanDataModel *)Revan_DataModel {
    return objc_getAssociatedObject(self, &kRevan_DataModelKey);
}

/** 初始化数据 */
- (void)setRevan_InitData:(id)Revan_InitData {
    objc_setAssociatedObject(self, &kRevan_InitDataKey, Revan_InitData, OBJC_ASSOCIATION_RETAIN);
}

- (id)Revan_InitData {
    return objc_getAssociatedObject(self, &kRevan_InitDataKey);
}


#pragma mark - 私有关联属性
//view已经加载完成
- (void)setRevan_ViewDidLoad:(BOOL)Revan_viewDidLoad {
    objc_setAssociatedObject(self, &kRevan_ViewDidLoadKey, @(Revan_viewDidLoad), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)Revan_viewDidLoad {
    return [objc_getAssociatedObject(self, &kRevan_ViewDidLoadKey) boolValue];
}

//view显示
- (void)setRevan_IsViewAppearred:(BOOL)Revan_IsViewAppearred {
    objc_setAssociatedObject(self, &kRevan_IsViewAppearredKey, @(Revan_IsViewAppearred), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)Revan_IsViewAppearred {
    return [objc_getAssociatedObject(self, &kRevan_IsViewAppearredKey) boolValue];
}


#pragma mark - Public Method
/**
 声明UIScrollView
 */
- (UIScrollView *)revan_InnerScrollView {
    UIScrollView *scrollView = nil;
    if ([self isKindOfClass:[UITableViewController class]]) {
        scrollView = [(UITableViewController *)self tableView];
    }
    else if ([self isKindOfClass:[UICollectionViewController class]]) {
        scrollView = [(UICollectionViewController *)self collectionView];
    }
    return scrollView;
}

/**
 声明请求数据的Model-Class
 */
- (Class)revan_DataModelClass {
    return nil;
}

/**
 声明Cell-Class
 */
- (Class)revan_CellClass {
    return nil;
}

/**
 状态栏样式
 */
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
/**
 通用初始化
 */
- (void)revan_CommonInit {
    self.Revan_IsRevanController = YES;
    //自动刷新定时器
}

/**
 dealloc
 */
- (void)revan_CommonDealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self revan_UnloadDataModel];
    [[self revan_InnerScrollView] setDelegate:nil];
}


/**
 加载Model
 */
- (void)revan_LoadDataModel {
    
    [self revan_UnloadDataModel];
    //获取请求数据对象
    Class DataModelClass = [self revan_DataModelClass];
    if (DataModelClass) {
        //实例化这个请求数据对象并且传入初始化值
        RevanDataModel *model = [DataModelClass performSelector:@selector(revan_createWithInitData:) withObject:self.Revan_InitData];
        //给Revan_DataModel属性赋值
        [self setRevan_DataModel:model];
    }
    
    RevanDataModel *dataModel = self.Revan_DataModel;
    
    if (dataModel) {
        Class cellClass = [self revan_CellClass];
        if (cellClass) {
            //cell 标识
            [dataModel setCellIdentify:NSStringFromClass(cellClass)];
        }
        // KVO
        [dataModel addObserver:self forKeyPath:kRevanDataSourceKEY options:NSKeyValueObservingOptionNew context:nil];
        [dataModel addObserver:self forKeyPath:kRevanDataFetchResultKEY options:NSKeyValueObservingOptionNew context:nil];
        [dataModel addObserver:self forKeyPath:kRevanDataUploadResultKEY options:NSKeyValueObservingOptionNew context:nil];
        [dataModel addObserver:self forKeyPath:kRevanDataDeleteResultKEY options:NSKeyValueObservingOptionNew context:nil];
        [dataModel addObserver:self forKeyPath:kRevanDataAPIResponseKEY options:NSKeyValueObservingOptionNew context:nil];
        /**
         *  这个如果 是在＋（）createWithInitData 使用，没有效果。
         
         */
        dataModel.ownerVC = self;
    }
}


/**
 销毁Model
 */
- (void)revan_UnloadDataModel {
    RevanDataModel *dataModel = self.Revan_DataModel;
    if (dataModel) {
        [dataModel removeObserver:self forKeyPath:kRevanDataSourceKEY];
        [dataModel removeObserver:self forKeyPath:kRevanDataFetchResultKEY];
        [dataModel removeObserver:self forKeyPath:kRevanDataUploadResultKEY];
        [dataModel removeObserver:self forKeyPath:kRevanDataDeleteResultKEY];
        [dataModel removeObserver:self forKeyPath:kRevanDataAPIResponseKEY];
        
        [dataModel revan_destroyListModelInstance];
        
        [self setRevan_DataModel:nil];
    }
}



/**
 开始加载数据
 */
- (void)revan_StartAsyncFetchData {
    //判断是否关联网络请求model
    if (self.Revan_DataModel) {
        //更换网络状态
        [self revan_ShowInfoView:RevanLoadingStateLoading];
        //加载网络
        [self.Revan_DataModel revan_fetchData];
    }
}


/**
 显示和刷新网络状态
 
 @param state 网络状态
 */
- (void)revan_ShowInfoView:(RevanLoadingState)state {
    
    if (self.Revan_IsShowLoadingInfo) {
        if (state == RevanLoadingStateDefault) {
            [self.Revan_LoadingInfoView removeFromSuperview];
            [self setRevan_LoadingInfoView:nil];
            [[self revan_InnerScrollView] setScrollEnabled:YES];
            return;
        }
        else {
            RevanLoadingInfoView *infoView = (RevanLoadingInfoView *)self.Revan_LoadingInfoView;
            if (!infoView) {
                infoView = [RevanLoadingInfoView loadCurrentNib];
                [infoView.onInfoViewBtn addTarget:self action:@selector(onTapInfoView:) forControlEvents:UIControlEventTouchUpInside];
                [self setRevan_LoadingInfoView:infoView];
            }
            [infoView setState:state];
            
            if (self.isViewLoaded) {
                if (infoView.superview != self.view) {
                    CGRect frame = self.view.bounds;
                    [infoView setFrame:frame];
                    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                    [self.view addSubview:infoView];
                }
                else {
                    [self.view bringSubviewToFront:infoView];
                }
                
                if (state == RevanLoadingStateEmpty) {
                    [[self revan_InnerScrollView] setScrollEnabled:YES];
                }
                else {
                    [[self revan_InnerScrollView] setScrollEnabled:NO];
                }
            }
        }
    }
}


/**
 创建控制器实例
 */
+ (instancetype)revan_createInstance {
    NSString *storyboardName = [self revan_storyboardName];
    if (storyboardName) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
        return controller;
    }
    return [[self class] new];
}

/**
 sb名称
 */
+ (NSString *)revan_storyboardName {
    return nil;
}


// 对table 或者 collectview 操作
- (void)revan_adjustScrollView:(UIScrollView *)scrollView {
    adjustsScrollViewInsets_NO(scrollView, self);
}
- (void)revan_adjustTableView:(UITableView *)tableView {
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    adjustsScrollViewInsets_NO(tableView, self);
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

- (void)revan_adjustCollectionView:(UICollectionView *)collect {
    adjustsScrollViewInsets_NO(collect, self);
}

- (void)revan_DataChanged {}
- (void)revan_DataUploadedWithErrorCode:(int)aErrorCode {}
- (void)revan_DataFecthedSuccess:(BOOL)aSuccess {}
- (void)revan_DataDeletedSucessess:(BOOL)aSuccess {}
- (void)revan_DataHttpApiResult:(NSDictionary *)result {}


#pragma mark - 交互方法
- (void)revan_ViewDidLoad {
    if (self.Revan_IsRevanController == NO) {
        return;
    }
    // 设置导航栏是否透明
    if (self.Revan_IsNavBarAlpha) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉导航栏底部的黑线
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    [self setRevan_ViewDidLoad:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.firstObject == self) {
            [self setTitle:self.navigationController.tabBarItem.title];
        }
        else if (self.navigationController.viewControllers.lastObject == self) {
            [self setHidesBottomBarWhenPushed:YES];
        }
        
        if (self.Revan_ShowCloseButton) {
            UIBarButtonItem *closeButton = [UIBarButtonItem itemWithTarget:self
                                                                    action:@selector(onBackButtonPressed:)
                                                                     image:[UIImage imageNamed:@"btn_exit"]];
            self.navigationItem.leftBarButtonItem = closeButton;
        }
        else {
            if (self.navigationController.viewControllers.lastObject == self && self.navigationController.viewControllers.count > 1) {
                
                UIImage *img = [UIImage revan_assetImageName:@"btn_nav_back"
                                       inDirectoryBundleName:@"BaseMVCSource"
                                                commandClass:NSClassFromString(@"RevanDataModel")];
                UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonPressed:)];
//                UIBarButtonItem *backButtonItem = [UIBarButtonItem itemWithTarget:self
//                                                                           action:@selector(onBackButtonPressed:)
//                                                                            image:img];
                self.navigationItem.leftBarButtonItem = backButtonItem;
            }
        }
    }
    
//MARK:刷新
    UIScrollView *scrollview = [self revan_InnerScrollView];
    if (scrollview) {
        if (self.Revan_IsNavBarHide == NO) {
            [scrollview setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + 20.0f, 0.0f, self.tabBarController.tabBar.bounds.size.height, 0.0)];
        }
        
        if (self.Revan_NeedPullRefesh) {
            __weak typeof(self) weakSelf = self;
            scrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf revan_StartAsyncRefreshData];
            }];
        }
        if (self.Revan_NeedLoadMore) {
            __weak typeof(self) weakSelf = self;
            scrollview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf revan_StartAsyncFetchMoreData];
            }];
        }
    }
    
// 网络加载标识
    if (self.Revan_LoadingInfoView) {
        if (self.Revan_LoadingInfoView.superview) {
            [self.Revan_LoadingInfoView.superview bringSubviewToFront:self.Revan_LoadingInfoView];
        }
        else {
            [self revan_ShowInfoView:self.Revan_LoadingInfoView.state];
        }
    }
    else if (!self.Revan_DataModel.dataFetched) {
        [self revan_ShowInfoView:RevanLoadingStateLoading];
    }
    
    [self revan_StartAsyncFetchData];
    
    [self revan_DataChanged];
}

- (void)revan_ViewWillAppear:(BOOL)animated {
    if (self.Revan_IsRevanController == NO) {
        return;
    }
    // 设置导航栏是否透明
    if (self.Revan_IsNavBarAlpha) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉导航栏底部的黑线
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
//    if (self.DVL_IsTimerAllowSelfLive) {
//        [self.DVL_DataModel startTimer];
//    }
    // 设置导航栏是否隐藏
    [self.navigationController setNavigationBarHidden:self.Revan_IsNavBarHide animated:animated];
    
    if ([self Revan_IsViewAppearred] == NO) {
        [self setRevan_IsViewAppearred:YES];
    }
    //设置状态条状态
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)revan_ViewWillDisappear:(BOOL)animated {
    if (!self.Revan_IsRevanController) {
        return;
    }
//    if (self.DVL_IsTimerAllowSelfLive) {
//        [self.DVL_DataModel endTimer];
//    }
}

- (void)revan_ViewDidDisappear:(BOOL)animated {
    
}

- (void)revan_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.Revan_IsRevanController == NO) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *controller = window.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    if (controller == self) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    else {
        [controller revan_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

#pragma mark - private Motheds
/**
 点击 网络加载状态view
 */
- (void)onTapInfoView:(id)sender {
    if (self.Revan_LoadingInfoView.state == RevanLoadingStateFailed) {
        [self.Revan_LoadingInfoView setState:RevanLoadingStateLoading];
        [self revan_StartAsyncFetchData];
    }
}

/**
 导航栏返回按钮
 */
- (void)onBackButtonPressed:(id)sender {
    //有导航栏
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

/**
 下拉刷新数据
 */
- (void)revan_StartAsyncRefreshData {
    [self.Revan_DataModel revan_refreshData];
}

/**
 上拉加载更多
 */
- (void)revan_StartAsyncFetchMoreData {
    if (self.Revan_DataModel.hasMore) {
        [self.Revan_DataModel revan_fetchMore];
    }
    else {
        if(self.Revan_NeedLoadMore){
            UIScrollView *scrollview = [self revan_InnerScrollView];
            [scrollview.mj_footer endRefreshing];
        }
    }
}

/**
 code错误结果
 */
- (int)errCodeOfResult:(id)aResult {
    if ([aResult isKindOfClass:[NSNumber class]]) {
        int errorCode = [aResult intValue];
        return errorCode;
    }
    else if ([aResult isKindOfClass:[RevanHttpResponse class]]) {
        int errorCode = [(RevanHttpResponse *)aResult code];
        return errorCode;
    }
    return 0;
}

#pragma mark - 监听KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //加载数据的model的KVO
    if (object == self.Revan_DataModel) {
        if (keyPath == kRevanDataSourceKEY) {//请求数据
            if (self.isViewLoaded) {
                [self revan_DataChanged];
            }
        }
        else {
            id result = change[NSKeyValueChangeNewKey];
            int errorCode = [self errCodeOfResult:result];
            BOOL success = (errorCode==0);
            
            if (keyPath == kRevanDataFetchResultKEY) {//请求数据结果
                if (success) {
                    if (self.Revan_DataModel.emptyData) {//空状态
                        [self revan_ShowInfoView:RevanLoadingStateEmpty];
                    }
                    else {//默认状态
                        [self revan_ShowInfoView:RevanLoadingStateDefault];
                    }
                }
                else {
                    if (self.Revan_LoadingInfoView.state == RevanLoadingStateLoading) {
                        [self revan_ShowInfoView:RevanLoadingStateFailed];
                    }
                }
                
                //加载了view
                if (self.isViewLoaded) {
                    UIScrollView *scrollView = [self revan_InnerScrollView];
                    if (scrollView) {
//                        if (self.Revan_NeedPullRefesh || self.Revan_HeaderGifView) {
//                            [scrollView.mj_header endRefreshing];
//                        }
                        if (self.Revan_NeedPullRefesh) {
                            [scrollView.mj_header endRefreshing];
                        }
                        if(self.Revan_NeedLoadMore){
                            [scrollView.mj_footer endRefreshing];
                        }
                        
                        if (success) {
                            if ([scrollView isKindOfClass:[UITableView class]]) {
                                UITableView *tableView = (UITableView *)scrollView;
                                [tableView reloadData];
                            }
                            else if ([scrollView isKindOfClass:[UICollectionView class]]) {
                                UICollectionView *collectionView = (UICollectionView *)scrollView;
                                [collectionView reloadData];
                            }
                            
                            if (self.Revan_NeedLoadMore) {
                                scrollView.mj_footer.hidden = NO;
                                if (!self.Revan_DataModel.hasMore) {
                                    [scrollView.mj_footer endRefreshingWithNoMoreData];
                                    scrollView.mj_footer.hidden = YES;
                                }
                            }
                        }
                    }
                    [self revan_DataFecthedSuccess:success];
                }
                
            }
            else if (keyPath == kRevanDataUploadResultKEY) {//上传数据请求结果
                if (self.isViewLoaded) {
                    [self revan_DataUploadedWithErrorCode:errorCode];
                }
            }
            else if (keyPath == kRevanDataDeleteResultKEY) {//删除数据请求结果
                if (self.isViewLoaded) {
                    [self revan_DataDeletedSucessess:success];
                }
            }
            else if (keyPath == kRevanDataAPIResponseKEY) {
                if (self.isViewLoaded) {
                    [self revan_DataHttpApiResult:result];
                }
            }
            
        }
    }
}

@end
