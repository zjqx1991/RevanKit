//
//  RevanTableViewController.m
//  AFNetworking
//
//  Created by Revan on 2018/8/6.
//

#import "RevanTableViewController.h"
#import "RevanListDataModel.h"

@interface RevanTableViewController ()
@property (nonatomic, strong) RevanListDataModel *Revan_DataModel;
@end

@implementation RevanTableViewController

- (void)revan_CommonInit {
    [super revan_CommonInit];
    [self setRevan_IsNavBarHide:NO];
    [self setRevan_IsNavBarAlpha:NO];
}

- (void)dealloc {
    [self revan_CommonDealloc];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)baseViewControllerInit {
    [self revan_CommonInit];
    [self revan_LoadDataModel];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self revan_ViewDidLoad];
    
    //    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    if ([self.Revan_DataModel conformsToProtocol:@protocol(UITableViewDataSource)]) {
        [self.tableView setDataSource:self.Revan_DataModel];
    }
    else {
        [self.tableView setDataSource:self];
    }
    
    [self.tableView setDelegate:self];
    
    if (self.tableView.tableFooterView == nil) {
        UIView *footer = [[UIView alloc] init];
        [self.tableView setTableFooterView:footer];
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    adjustsScrollViewInsets_NO(self.tableView, self);
}

- (void)revan_DataChanged {
    [self.tableView reloadData];
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
