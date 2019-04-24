//
//  RevanPageListDataModel.h
//  QMKit
//
//  Created by Revan on 2018/8/7.
//

#import "RevanListDataModel.h"

@interface RevanPageListDataModel : RevanListDataModel

@property (nonatomic, assign) long long totalCount; // 总数
@property (nonatomic, readonly) NSArray *addPageObjects;

// 给子类重写的类
- (void)revan_asyncFetchListAtPage:(NSInteger)aPageIndex isRefresh:(BOOL)aIsRefresh completion:(void (^)(BOOL isSuccess, NSArray *listArray,NSInteger count, long long totalCount))completion;


// 强制刷新使用
- (void)revan_fetchListAtPageIndex:(NSInteger)aPageIndex isRefresh:(BOOL)aIsRefresh;
@end
