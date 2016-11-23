//
//  SGSegmentedControlBottomView.m
//  SGSegmentedControlExample
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGSegmentedControl.git - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGSegmentedControlBottomView.h"

@implementation SGSegmentedControlBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 开启分页
        self.pagingEnabled = YES;
        // 没有弹簧效果
        self.bounces = NO;
        // 隐藏水平滚动条
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

/**
 *  给外界提供的方法（必须实现）
 *  @param index    外界控制器子控制器View的下表
 *  @param outsideVC    外界控制器（主控制器、self的父控制器）
 */
- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)outsideVC {
    
    CGFloat offsetX = index * self.frame.size.width;
    
    UIViewController *vc = outsideVC.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}


- (void)setChildViewController:(NSArray *)childViewController {
    _childViewController = childViewController;
    
    self.contentSize = CGSizeMake(self.frame.size.width * childViewController.count, 0);
}

@end


