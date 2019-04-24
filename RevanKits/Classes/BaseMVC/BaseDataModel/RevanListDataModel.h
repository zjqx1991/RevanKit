//
//  RevanListDataModel.h
//  AFNetworking
//
//  Created by Revan on 2018/8/7.
//

#import "RevanDataModel.h"

@interface RevanListDataModel : RevanDataModel <UICollectionViewDataSource, UITableViewDataSource>


/**
 获取列表数据元素

 @param index 下标
 */
- (id)revan_objectAtIndex:(NSUInteger)index;

/**
 列表个数
 */
- (NSUInteger)revan_count;

/**
 获取列表数据元素的下标

 @param object 元素
 @return 元素下标
 */
- (NSInteger)revan_indexOfObject:(id)object;

/**
 列表数据最后一个元素
 */
- (id)revan_lastObject;

/**
 列表数据
 */
- (NSArray *)revan_array;


- (void)revan_setArray:(NSArray *)array;
- (void)revan_insertObject:(id)object atIndex:(NSUInteger)index;
- (void)revan_insertDataSource:(NSArray *)array atIndexes:(NSIndexSet *)indexes;
- (void)revan_replaceObject:(id)object atIndex:(NSUInteger)index;
- (void)revan_removeObjectAtIndex:(NSUInteger)index;
- (void)revan_removeObject:(id)object;
- (void)revan_removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)revan_removeObjectsInArray:(NSArray *)otherArray;
- (void)revan_addObjectsFromArray:(NSArray *)objects;
#pragma mark - 交换
- (void)revan_exchangeObjectAtIndex:(NSInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

@end
