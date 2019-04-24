//
//  RevanCollectionViewController.m
//  AFNetworking
//
//  Created by Revan on 2018/8/6.
//

#import "RevanCollectionViewController.h"
#import "RevanListDataModel.h"

@interface RevanCollectionViewController ()
@property (nonatomic, strong) RevanListDataModel *Revan_DataModel;
@end

@implementation RevanCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc {
    [self revan_CommonDealloc];
}

- (void)revan_CommonInit {
    [super revan_CommonInit];
    [self setRevan_IsNavBarHide:NO];
    [self setRevan_IsNavBarAlpha:NO];
}

- (void)baseViewControllerInit {
    [self revan_CommonInit];
    [self revan_LoadDataModel];
}

- (id)init {
    self = [super init];
    if (self) {
        [self baseViewControllerInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self baseViewControllerInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self baseViewControllerInit];
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self baseViewControllerInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self revan_ViewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    if ([self.Revan_DataModel conformsToProtocol:@protocol(UICollectionViewDataSource)]) {
        [self.collectionView setDataSource:self.Revan_DataModel];
    }
    else {
        [self.collectionView setDataSource:self];
    }
    [self.collectionView setDelegate:self];
    
    adjustsScrollViewInsets_NO(self.collectionView, self);
}

- (void)revan_DataChanged {
    [self.collectionView reloadData];
}

#pragma mark - Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self revan_ViewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self revan_ViewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self revan_ViewDidDisappear:animated];
}

@end
