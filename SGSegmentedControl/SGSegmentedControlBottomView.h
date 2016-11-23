//
//  SGSegmentedControlBottomView.h
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

#import <UIKit/UIKit.h>

@interface SGSegmentedControlBottomView : UIScrollView
/** 子控制器的个数 */
@property (nonatomic, strong) NSArray *childViewController;

/** 对象方法创建 SGSegmentedControlBottomView */
- (instancetype)initWithFrame:(CGRect)frame;
/** 类方法创建 SGSegmentedControlBottomView */
+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame;

/**
 *  展示对应下标的对应子控制器的view（给外界提供的方法 -> 必须实现）
 *  @param index    外界控制器子控制器View的下标
 *  @param outsideVC    外界控制器（主控制器、self的父控制器）
 */
- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)outsideVC;


@end
