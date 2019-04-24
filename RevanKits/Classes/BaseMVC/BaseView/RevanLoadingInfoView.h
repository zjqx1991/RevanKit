//
//  RevanLoadingInfoView.h
//  QMKit
//
//  Created by Revan on 2018/8/8.
//

#import <UIKit/UIKit.h>
#import "UIViewController+RevanVC.h"


@interface RevanLoadingInfoView : UIView<RevanLoadingViewProtocol>
/** 状态 */
@property (assign, nonatomic) RevanLoadingState state;
@property (weak, nonatomic) IBOutlet UIButton *onInfoViewBtn;

/**
 加载xib
 */
+ (id)loadCurrentNib;

@end
