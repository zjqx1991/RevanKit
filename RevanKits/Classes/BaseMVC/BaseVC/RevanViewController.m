//
//  RevanViewController.m
//  AFNetworking
//
//  Created by Revan on 2018/8/6.
//

#import "RevanViewController.h"

@interface RevanViewController ()

@end

@implementation RevanViewController


- (void)dealloc {
    [self revan_CommonDealloc];
}

- (void)revan_CommonInit {
    [super revan_CommonInit];
    [self setRevan_IsNavBarHide:YES];
    [self setRevan_IsNavBarAlpha:NO];
}

- (void)baseViewControllerInit {
    [self revan_CommonInit];
    [self revan_LoadDataModel];
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

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self revan_ViewDidLoad];
}

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


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
