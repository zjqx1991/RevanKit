//
//  RevanPageListDataModel.m
//  QMKit
//
//  Created by Revan on 2018/8/7.
//

#import "RevanPageListDataModel.h"

const int kRevanPageFirstIndex = 1;
NSInteger _pageIndex;
NSInteger _curFetchIndex;

@interface RevanPageListDataModel ()

@end

@implementation RevanPageListDataModel


#pragma mark - private

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _reset];
    }
    return self;
}

- (void)_reset {
    _curFetchIndex = kRevanPageFirstIndex;
    _pageIndex = kRevanPageFirstIndex;
    _hasMore = NO;
}

#pragma mark - 重写父类方法
- (void)revan_fetchData {
    [self _reset];
    [self revan_fetchListAtPageIndex:_pageIndex isRefresh:YES];
}

- (void)revan_refreshData {
    [self _reset];
    [self revan_fetchListAtPageIndex:_pageIndex isRefresh:YES];
}

- (void)revan_fetchMore {
    if (self.hasMore) {
        _pageIndex += 1;  //多次请求，直接可以过滤掉了
        [self revan_fetchListAtPageIndex:_pageIndex isRefresh:NO];
    }
}


/**
 强制刷新

 @param aPageIndex 当前页
 @param aIsRefresh 是否刷新
 */
- (void)revan_fetchListAtPageIndex:(NSInteger)aPageIndex isRefresh:(BOOL)aIsRefresh {
    if (labs(aPageIndex - _curFetchIndex ) > 1) {
        return;
    }
    
    [self revan_asyncFetchListAtPage:aPageIndex isRefresh:aIsRefresh completion:^(BOOL isSuccess, NSArray *listArray, NSInteger count, long long totalCount) {
        
        _addPageObjects = nil;
        
        if (isSuccess) {
            if (listArray.count >  0) {
                _hasMore = YES;
                _pageIndex = aPageIndex;
                _curFetchIndex = aPageIndex;
            }
            else {
                _hasMore = NO;
                if (aIsRefresh == NO) {
                    //下拉加载更多
                    _pageIndex -= 1;
                }
            }
            
            [self setTotalCount:totalCount];
            
            if (aIsRefresh) {
                _addPageObjects = listArray;
                [self revan_setArray:listArray];
            }
            else { //加载更多
                _addPageObjects = listArray;
                [self revan_addObjectsFromArray:listArray];
            }
        }
        else {
            if (aIsRefresh == NO) {
                _pageIndex = _curFetchIndex;
            }
            else {
                _pageIndex = aPageIndex;
            }
            
        }
    }];
}

// 给子类重写的类
- (void)revan_asyncFetchListAtPage:(NSInteger)aPageIndex isRefresh:(BOOL)aIsRefresh completion:(void (^)(BOOL isSuccess, NSArray *listArray,NSInteger count, long long totalCount))completion {
    
}



#pragma mark - overwrite
- (void)revan_insertObject:(id)object atIndex:(NSUInteger)index
{
    [self setTotalCount:self.totalCount+1];
    [super revan_insertObject:object atIndex:index];
}

- (void)revan_removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    [self setTotalCount:MAX(0,self.totalCount-indexes.count)];
    [super revan_removeObjectsAtIndexes:indexes];
}

- (void)revan_setArray:(NSArray *)array
{
    if (self.totalCount == 0)
    {
        [self setTotalCount:array.count];
    }
    [super revan_setArray:array];
}

- (void)revan_addObjectsFromArray:(NSArray *)objects
{
    [super revan_addObjectsFromArray:objects];
}

#pragma mark - tableview datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row >= self.revan_count - 7) {
        [self revan_fetchMore];
    }
    return cell;
}

#pragma mark - collectionview datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row >= self.revan_count - 7) {
        [self revan_fetchMore];
    }
    return cell;
}

@end
