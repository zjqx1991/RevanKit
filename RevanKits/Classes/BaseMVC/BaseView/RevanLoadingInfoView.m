//
//  RevanLoadingInfoView.m
//  QMKit
//
//  Created by Revan on 2018/8/8.
//

#import "RevanLoadingInfoView.h"
#import "UIImage+RevanVC.h"

@interface RevanLoadingInfoView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *stateImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *stateTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *stateTipsLabel;

@end

@implementation RevanLoadingInfoView

/**
 加载视图内容
 */
- (void)setState:(RevanLoadingState)state {
    _state = state;
    switch (state) {
        case RevanLoadingStateFailed: {
            UIImage *img = [UIImage revan_assetImageName:@"failed"
                                   inDirectoryBundleName:@"BaseMVCSource"
                                            commandClass:[self class]];
            [self.stateImageView setImage:img];
            [self.stateTitleLabel setText:@"网络异常，检查网络"];
            [self.stateTipsLabel setText:@"点击刷新"];
        }
            break;
            
        case RevanLoadingStateEmpty: {
            UIImage *img = [UIImage revan_assetImageName:@"bg_empty"
                                   inDirectoryBundleName:@"BaseMVCSource"
                                            commandClass:[self class]];
            [self.stateImageView setImage:img];
            [self.stateTitleLabel setText:@"暂无交易记录！"];
            [self.stateTipsLabel setText:@""];
        }
            break;
            
        case RevanLoadingStateLoading: {
            UIImage *img = [UIImage revan_assetImageName:@"bg_empty"
                                   inDirectoryBundleName:@"BaseMVCSource"
                                            commandClass:[self class]];
            [self.stateImageView setImage:img];
            [self.stateTitleLabel setText:@"加载中..."];
            [self.stateTipsLabel setText:@""];
        }
            break;
            
        default:
            break;
    }
}

+ (id)loadCurrentNib {
   return [self loadCurrentNib:@"RevanLoadingInfoView"
   inDirectoryBundleName:@"BaseMVCSource"
            currentClass:self];
}

+ (id)loadCurrentNib:(NSString *)nibName inDirectoryBundleName:(NSString *)bundleName currentClass:(Class)Class {
    /** 当前bundle */
    NSBundle *currentBundle = [NSBundle bundleForClass:Class];
    /** 资源在命名空间的路径 */
    NSString *nibNamePath = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, nibName];
    return [[currentBundle loadNibNamed:nibNamePath owner:nil options:nil] lastObject];
}


@end
