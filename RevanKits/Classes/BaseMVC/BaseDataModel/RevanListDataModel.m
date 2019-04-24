//
//  RevanListDataModel.m
//  AFNetworking
//
//  Created by Revan on 2018/8/7.
//

#import "RevanListDataModel.h"


@interface RevanListDataModel () {
    NSArray *_dataSource;
}
@end

@implementation RevanListDataModel
/**
 获取列表数据元素
 
 @param index 下标
 */
- (id)revan_objectAtIndex:(NSUInteger)index {
    if (index < _dataSource.count) {
        return [_dataSource objectAtIndex:index];
    }
    else {
        NSAssert(0, @"数据越界");
        return nil;
    }
}

/**
 列表个数
 */
- (NSUInteger)revan_count {
    return [_dataSource count];
}

/**
 获取列表数据元素的下标
 
 @param object 元素
 @return 元素下标
 */
- (NSInteger)revan_indexOfObject:(id)object {
    return [_dataSource indexOfObject:object];
}

/**
 列表数据最后一个元素
 */
- (id)revan_lastObject {
    return [_dataSource lastObject];
}

/**
 列表数据
 */
- (NSArray *)revan_array {
    return [NSArray arrayWithArray:_dataSource];
}



- (void)revan_setArray:(NSArray *)array {
    if (array) {
        [self setValue:[array mutableCopy] forKeyPath:kRevanDataSourceKEY];
        if (array.count <= 0) {
            _emptyData = YES;
        }
        else {
            _emptyData = NO;
        }
    }
    else {
        _emptyData = YES;
        [self setValue:nil forKeyPath:kRevanDataSourceKEY];
    }
}

- (void)revan_insertObject:(id)object atIndex:(NSUInteger)index {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray insertObject:object atIndex:index];
}

- (void)revan_insertDataSource:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray insertObjects:array atIndexes:indexes];
}

- (void)revan_replaceObject:(id)object atIndex:(NSUInteger)index {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray replaceObjectAtIndex:index withObject:object];
}

- (void)revan_removeObjectAtIndex:(NSUInteger)index {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray removeObjectAtIndex:index];
}

- (void)revan_removeObject:(id)object {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray removeObject:object];
}

- (void)revan_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray removeObjectsAtIndexes:indexes];
}

- (void)revan_removeObjectsInArray:(NSArray *)otherArray {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray removeObjectsInArray:otherArray];
}

- (void)revan_addObjectsFromArray:(NSArray *)objects {
    [self revan_insertDataSource:objects atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([_dataSource count], [objects count])]];
}

#pragma mark - 交换
- (void)revan_exchangeObjectAtIndex:(NSInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    NSMutableArray *KVCArray = [self mutableArrayValueForKey:kRevanDataSourceKEY];
    [KVCArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}


#pragma mark - table view dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentify forIndexPath:indexPath];
    //给cell打一个 tag
    [cell setTag:indexPath.row];
    return cell;
}

#pragma mark - collectionview dataSouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentify forIndexPath:indexPath];
    [cell setTag:indexPath.row];
    return cell;
}

@end
